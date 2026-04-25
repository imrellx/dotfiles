# Niri universal-clipboard uses terminal-aware dispatch (F2), not Hyprland-style universal Insert (F1)

## Status

Accepted — 2026-04-25

## Context

Omarchy's "universal clipboard" pattern (single-machine unified `Super+C/X/V` shortcuts, see ADR-0004 for why we want it) is implemented on Hyprland via the built-in `sendshortcut` dispatcher: `Super+C` → emits `Ctrl+Insert` to the focused window, `Super+V` → emits `Shift+Insert`. The `Ctrl+Insert`/`Shift+Insert` pair is the xterm-era universal clipboard convention that *some* GUI apps and *most* terminals honor.

Niri has no `sendshortcut` equivalent. Implementing universal clipboard on niri requires synthesizing the keystrokes ourselves via `wtype`. Two real shapes were considered:

- **F1 — universal Insert.** All three niri binds emit fixed key combinations regardless of focused app: `Mod+C` → `wtype -M ctrl -k Insert`, `Mod+V` → `wtype -M shift -k Insert`. One rule, no app detection.
- **F2 — terminal-aware dispatch.** New helper `.local/bin/dot-send-shortcut` reads `niri msg --json focused-window`, branches on `app_id` against a terminal regex (`ghostty|alacritty|wezterm|kitty|foot`), and emits `Ctrl+Shift+letter` via `wtype` for terminals or `Ctrl+letter` for everything else.

Pre-implementation research established what each terminal actually does with `Ctrl+Insert` and `Shift+Insert` by default on Linux:

| Terminal | `Ctrl+Insert` (copy) | `Shift+Insert` (paste) |
|---|---|---|
| Ghostty | binds to CLIPBOARD | binds to **PRIMARY** (overridden later in `Config.zig:6804-6808`) |
| Alacritty | **unbound** | PRIMARY |
| WezTerm | PRIMARY | PRIMARY |
| Kitty | **unbound** | **unbound** |
| Foot | **unbound** | PRIMARY |

Wayland has two separate selection buffers (`primary-selection-v1` for PRIMARY, `wl-data-control` for CLIPBOARD); they do not auto-mirror. F1 as written would either paste nothing or paste the wrong content in 4 of 5 terminals.

The reason Omarchy's F1 works at all is that Omarchy ships per-terminal config patches (`omarchy/config/ghostty/config:26-27`, `omarchy/config/alacritty/alacritty.toml:22-23`, `omarchy/config/kitty/kitty.conf:14-15`) that explicitly bind `Ctrl+Insert`/`Shift+Insert` to CLIPBOARD operations on each supported terminal. Omarchy doesn't ship configs for WezTerm or foot, so those terminals would still be broken under their own scheme.

By contrast, `Ctrl+Shift+C/V` is the default copy/paste in all five of those terminals out of the box, hitting CLIPBOARD.

## Decision

**F2.** Niri binds `Mod+C/X/V` to `dot-send-shortcut copy|cut|paste`. The script does focused-app detection and emits `Ctrl+Shift+letter` for terminals, `Ctrl+letter` for non-terminals, via `wtype`.

## Why

1. **F2 inherits a working baseline.** `Ctrl+Shift+C/V` is universal across modern terminals; F2 needs no per-terminal config patches. F1 (in our setup, without patches) is broken-by-default in 4 of 5 terminals.
2. **F1-with-patches relocates the work, doesn't reduce it.** Going F1-with-Omarchy-style-patches means we'd ship terminal config patches in `.config/ghostty/`, `.config/alacritty/`, `.config/kitty/`, etc. Adding a new terminal would mean shipping a new patch. Adding a new terminal under F2 is one regex addition in one script.
3. **Pattern continuity.** `.local/bin/dot-clip-paste-on-select` already does focused-app detection (`niri msg --json focused-window`, branches on `app_id` for ghostty's `Ctrl+Shift+V`). F2 extends the existing, working pattern. F1 introduces a new pattern (rely on terminal-side bindings to land correctly) for no offsetting win.
4. **No PRIMARY/CLIPBOARD reconciliation needed.** Under F2, niri sends the keystroke that the focused app already maps to a CLIPBOARD operation. Under F1, niri would have to mirror the system clipboard into PRIMARY on every copy (`wl-copy` + `wl-copy --primary`) just so paste lands the right content.

## Consequences

- New file: `.local/bin/dot-send-shortcut`. Single script, takes `copy|cut|paste`, dispatches via `niri msg` + `wtype`. Joins the `dot-*` script fleet (per ADR-0003).
- New package: `wtype` added to `_install/default/packages/arch`. `wlrctl` (already installed) can hold modifiers while typing characters but cannot emit special keys like `Insert` directly; `wtype` is the right tool for the synthesis layer regardless of F1/F2 — F2 just uses it for `letter+modifier` combos rather than `Insert+modifier`.
- Terminal regex lives inside `dot-send-shortcut`. When the user adds Alacritty / WezTerm / Kitty / Foot via the Phase 2a `install-terminal` script (or via Phase 2d), the regex gets one alternation added.
- This decision composes with ADR-0004: `Mod+C/X/V` only become available because `Mod` (Super) is no longer the WM modifier. ADR-0004 freed the keys; this ADR decides what they emit.
- Hyprland (Phase 2b) can use the built-in `sendshortcut` dispatcher and skip `dot-send-shortcut` entirely, OR call `dot-send-shortcut` for consistency with niri. Phase 2b decides; not blocked by this ADR.
- The `dot-clip-paste-on-select` script (the post-history-selection auto-paste, referenced by `.config/elephant/clipboard.toml`) keeps its existing shape — it already does the same kind of dispatch and was the prior-art for F2.
