# Cross-platform keybind philosophy: `Alt`-as-WM, `Super`/`Cmd`-as-clipboard

## Status

Accepted — 2026-04-25

## Context

The user runs a MacBook Pro as daily driver and Arch laptops as secondary machines. Daily-driver friction is dominated by muscle-memory cost when keybinds diverge between the two platforms. The user has stated explicitly: bindings on macOS and Linux "have to be identical in that sense if we can get them or close to that. So I don't actually have to think about them."

macOS-side, Paneru is the WM (`~/.config/paneru/paneru.toml`). Paneru uses `Alt` as its modifier (`Alt+h/j/k/l` focus, `Alt+c` center, `Alt+f` fullwidth, `Alt+Shift+letter` for swap variants, `Ctrl+Alt+letter` for compound actions). It can't use `Cmd` because macOS reserves `Cmd` for OS shortcuts; that's why every Mac tiling WM (yabai, Aerospace, Paneru) anchors on `Alt`.

Linux-side, the convention across most tiling Wayland WMs (niri, Hyprland, Sway) is `Super` for the WM modifier and `Ctrl`/`Ctrl+Shift` for clipboard. The opposite convention to Paneru.

Two parallel choices, one for each modifier role:

- **WM modifier on Linux**: pick `Alt` (mirrors Paneru, breaks Linux convention) or `Super` (matches Linux convention, breaks Paneru parity).
- **Clipboard modifier on Linux**: pick `Super` (structural mirror of macOS `Cmd` — same physical key under the thumb) or `Ctrl`/`Ctrl+Shift` (Linux convention).

Picking by Linux convention gives ergonomic divergence between Mac and Linux for the user's most-used bindings. Picking by Paneru parity inverts the niri-default conventions but gives identical key combos for identical actions across platforms.

## Decision

**WM modifier is `Alt` on both platforms. Clipboard modifier is `Cmd` on macOS (OS-native, no work) and `Super` on Linux (custom-bound).**

Niri's keybinds in this repo will be reshaped to mirror Paneru's `paneru.toml` end-to-end (Phase 2b, full port). Hyprland's binds, when added in Phase 2b, follow the same rule. Anywhere a Paneru action exists, the Linux equivalent uses the same key.

## Why

1. **Paneru is fixed.** `Cmd` is OS-claimed on macOS. Paneru cannot move off `Alt`. So if parity exists, it has to be Linux moving to match Mac, not the other way.
2. **`Cmd` and `Super` are structurally the same key.** Both sit immediately left of space, both are pressed with the thumb, both are the "OS-level" modifier on their respective keyboards. Muscle memory transfers across the rename. Pressing "thumb-modifier + C" produces "copy" on both platforms, even though the modifier is *named* differently.
3. **The Linux loss is bounded.** `Alt`-as-WM eats whatever `Alt+letter` combos niri/Hyprland claim. Paneru only claims `h/j/k/l/u/i/r/e/f/c/t/s/w/n` — the rest of the alphabet stays free for app-internal shortcuts and the user's Raycast-equivalent launcher binds. Tiling-WM users in general don't rely on app menu mnemonics (`Alt+F` = File menu, etc.), so the practical cost is small.
4. **The user explicitly accepted this trade.** Asked directly whether `Alt`-as-WM on Linux is the right call given the menu-mnemonic loss, the user confirmed: "yes, both makes sense."

## Consequences

- Every future niri/Hyprland keybind decision is a translation from Paneru, not a fresh design. The first reference is always `~/.config/paneru/paneru.toml`.
- Phase 2b includes a "full Paneru mirror" sweep across the niri config. Bindings that aren't in Paneru (workspace switching by number, screenshot binds, etc.) stay on Super or pick whatever modifier is most consistent with the rest of the niri layer.
- The universal-clipboard work (Phase 2d, see ADR-0005) sits on top of this: it can use `Super+C/V/X` exactly because `Super` is no longer the WM modifier.
- If Paneru itself changes its bindings, the Linux side follows. Paneru is the canonical reference; niri/Hyprland configs are downstream.
- Linux apps that bind `Alt+letter` for their own purposes (Firefox `Alt+F` = File menu, GTK menu mnemonics, some custom user shortcuts) lose those combos *for any letter the WM claims*. Letters the WM doesn't claim still pass through to apps. The user uses Raycast-style launcher shortcuts on `Alt+letter` and is fine with this scoped loss.
