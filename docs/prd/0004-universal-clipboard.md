# Universal clipboard for niri (Phase 2d)

## Problem Statement

Copy and paste in CLI environments — specifically Ghostty running under niri on Arch — was reported as "almost unusable" on a fresh dotfiles install on a test laptop. Pressing the usual combinations (`Ctrl+C`, `Ctrl+Shift+C`) appeared to do nothing.

Beyond the immediate breakage, there's a steady-state ergonomics problem. The user runs a MacBook Pro as daily driver where `Cmd+C/V/X` works universally across CLI and GUI, with no app-by-app variation. When switching to a Linux laptop, the same actions split into `Ctrl+Shift+C/V` for terminals and `Ctrl+C/V` for GUIs, with a constant cognitive switch between platforms. The user described it as "the solution is I want this universal clipboard from omarchy. It's incredible. And in omarchy it just works."

## Solution

Bring Omarchy's "universal clipboard" pattern to this dotfiles repo, scoped to the niri + Arch GUI stack. Single-machine unified shortcuts that work identically in terminals and GUIs:

- `Super+C` — copy
- `Super+X` — cut
- `Super+V` — paste
- `Super+Ctrl+V` — clipboard history (Walker provider)

On macOS, parity is achieved with zero new work: `Cmd+C/V/X` is OS-native; Raycast Clipboard History covers `Cmd+Ctrl+V`. The Linux side is the entire deliverable.

Niri has no equivalent of Hyprland's `sendshortcut` dispatcher. The implementation introduces a small helper, `dot-send-shortcut`, that reads `niri msg --json focused-window`, branches on `app_id` against a regex of known terminals, and emits `Ctrl+Shift+letter` via `wtype` for terminals or `Ctrl+letter` for everything else. The `Ctrl+Shift+letter` form is the universal default across modern terminals (Ghostty, Alacritty, WezTerm, Kitty, Foot — all confirmed) and the `Ctrl+letter` form is the universal default across GUI apps. No per-terminal config patches are required.

## User Stories

1. As a Linux user on Arch with niri, I want `Super+C` to copy the current selection in my terminal, so that I don't have to context-switch to `Ctrl+Shift+C`.
2. As a Linux user on Arch with niri, I want `Super+V` to paste in my terminal, so that I don't have to remember `Ctrl+Shift+V`.
3. As a Linux user on Arch with niri, I want `Super+C` to copy in any GUI app (browser, file manager, text editor), so that the same shortcut works everywhere on the same machine.
4. As a Linux user on Arch with niri, I want `Super+X` to cut in any GUI app, so that I have symmetry with copy and paste even though terminals don't honor cut.
5. As a Linux user on Arch with niri, I want `Super+Ctrl+V` to open my clipboard history picker (Walker), so that I can paste anything from recent history.
6. As a user with both a MacBook Pro and Arch laptops, I want my clipboard shortcuts to be identical across both platforms, so that switching machines doesn't cost cognitive effort.
7. As a user who might adopt a different terminal later (Alacritty / WezTerm / Kitty / Foot), I want the universal clipboard to work without per-terminal config patches, so that trying a new terminal is one regex addition rather than a config sweep.
8. As a user who copies images (e.g., Satty screenshots) into the clipboard, I want those entries to appear in the Walker history alongside text entries, so that I can paste images later from the picker.
9. As a user, I want any underlying clipboard plumbing breakage on a fresh install to be diagnosed before new shortcuts are layered on top, so that the new shortcuts don't inherit the same broken substrate.
10. As a user, I want the new niri bindings to not silently break actions I currently rely on (column centering, Walker history launcher), so that adopting universal clipboard doesn't introduce a regression mid-session.
11. As a future maintainer reading `.config/niri/config.kdl`, I want to understand why `Mod+C` invokes a script instead of being a niri layout action, so that I don't "fix" it back to the upstream default.
12. As a future maintainer, I want a clear written record of why F2 (terminal-aware dispatch) was chosen over F1 (universal `Ctrl+Insert`/`Shift+Insert`), so that I don't undo the choice without redoing the research.
13. As a user installing the dotfiles on a new Arch machine, I want `wtype` and any other missing clipboard packages installed automatically, so that universal clipboard works on first boot.
14. As a user, I want this work to be Arch-only (the only platform I run niri on), so that the install doesn't ship clipboard machinery on macOS or Debian where it isn't needed.
15. As a user planning to add Hyprland in Phase 2b, I want the option to either reuse `dot-send-shortcut` or switch to Hyprland's native `sendshortcut`, so that Phase 2b can choose independently of this PR.
16. As a user, I want the Walker clipboard history launcher to remain accessible after this change, just on a new chord (`Super+Ctrl+V` instead of `Super+V`), so that I don't lose history access while paste claims `Super+V`.
17. As a user, I want the cross-platform keybind philosophy (`Alt`-as-WM, `Super`/`Cmd`-as-clipboard) recorded as an ADR, so that future binds in this repo are designed against a stable foundation rather than re-litigated each time.
18. As a user, I want the universal-clipboard implementation choice (F2 over F1) recorded as an ADR with the per-terminal evidence, so that the rejected alternative isn't reintroduced later by someone who only reads Omarchy's manual and assumes F1.

## Implementation Decisions

**Modules.** One new code surface; the rest is config diff.

- **`dot-send-shortcut`** (new helper script in `.local/bin/`). The deep module. CLI: `dot-send-shortcut copy|cut|paste`. Encapsulates focused-window detection (`niri msg --json focused-window | jq -r .app_id`), terminal regex matching (`ghostty|alacritty|wezterm|kitty|foot`), and `wtype` invocation. Per-terminal special cases live inside this script's regex string, not in niri config or app configs. Joins the `dot-*` fleet per ADR-0003.
- **Niri bindings layer** — coordinated edits to `.config/niri/config.kdl`. Adds `Mod+C/X/V` and `Mod+Ctrl+V`. Relocates existing `Mod+C` (center-column) to `Mod+Shift+C` as a stopgap until Phase 2b's full Paneru port lands. Relocates existing `Mod+V` (Walker history launcher) to `Mod+Ctrl+V`, which matches the Omarchy shape exactly.
- **Package addition** — `wtype` added to `_install/default/packages/arch`. The only missing prerequisite. `wl-clipboard`, `wlrctl`, `elephant-clipboard-bin`, walker, niri are already installed.
- **Install-side wiring** — confirm `systemctl --user enable --now elephant.service` runs as part of the install path (or via `systemd --user` defaults shipped by `elephant-clipboard-bin`). If not enabled by the package post-install, the install script does it. The install also emits a one-line notice: "log out and back into niri before testing universal clipboard" — keybind reload happens at session start, and `wtype`/`wl-clipboard` need a session that knows the new wayland protocols are available.

**No changes to `dot-clip-paste-on-select`.** It already does the same focused-app dispatch for the auto-paste-on-select flow. It serves as prior art for `dot-send-shortcut`.

**Terminal-regex source of truth.** `dot-send-shortcut` and `dot-clip-paste-on-select` both branch on the same set of terminal `app_id` values. To prevent drift, the regex lives in one place — a constant inside `dot-send-shortcut` exported via a small helper, or duplicated literally with a cross-reference comment in each file. Implementation decides; the PRD requires that the two stay in sync.

**Selection-buffer convention.** F2 targets the CLIPBOARD selection (`wl-data-control` protocol), not PRIMARY. Every terminal's stock `Ctrl+Shift+C` and `Ctrl+Shift+V` writes/reads CLIPBOARD; every GUI's stock `Ctrl+C`/`Ctrl+V` writes/reads CLIPBOARD. PRIMARY is left alone — terminal-native middle-click selection-paste continues to work via the `primary-selection-v1` protocol independently of this PR.

**Image clipboard.** `Super+C` triggering a copy in an image-capable app (Satty, Firefox image right-click → copy) results in an image entry in the CLIPBOARD selection. Walker's clipboard provider, backed by `elephant-clipboard-bin`, surfaces image entries in the picker. This is treated as a verification gate during diagnostic check #2 above (extend the round-trip test to a binary entry). If image entries don't surface, that's an `elephant-clipboard-bin` configuration question to resolve in this PR.

**Architectural foundation (cross-references).**
- ADR-0004 (`docs/adr/0004-cross-platform-keybind-philosophy.md`): cross-platform `Alt`-as-WM and `Super`/`Cmd`-as-clipboard philosophy. Establishes why `Mod+C/V/X` are even available for clipboard.
- ADR-0005 (`docs/adr/0005-niri-clipboard-keystroke-synthesis-f2.md`): F2 (terminal-aware dispatch) over F1 (universal Insert). Per-terminal evidence and rationale.

**Diagnostic gate (pre-implementation).** Before merging keybind changes, reproduce the test-laptop "`Ctrl+Shift+C` does nothing in Ghostty" symptom on a fresh install and identify the root cause. Layering shortcuts on top of broken plumbing inherits the breakage. Concrete checks the diagnostic must run, in order:

1. **Verify the user-level `elephant.service` is running.** `systemctl --user status elephant`. If not running, `systemctl --user enable --now elephant.service` and confirm Walker's clipboard provider populates after copying once.
2. **Verify `wl-paste` round-trips a CLIPBOARD entry.** `printf hello | wl-copy && wl-paste` returns `hello`. If empty, the `wlr-data-control` protocol isn't being served — usually a niri session that needs restart after install.
3. **Verify `wl-paste --primary` round-trips a PRIMARY entry.** Confirms the `primary-selection-v1` protocol is alive (consumed by terminal middle-click paste, irrelevant to F2 directly but a useful canary).
4. **Verify Ghostty's stock `Ctrl+Shift+C` and `Ctrl+Shift+V` work.** If they don't, F2 is broken-by-construction on this machine because F2 leans on those defaults. Fix Ghostty/niri before adding bindings.
5. **Verify `wtype -M ctrl c` lands in the focused window.** Smoke test for the synthesis layer.

"Fixed" means all five pass on a clean install. The diagnostic is investigation, not a deliverable artifact (no `dot-clipboard-doctor` script). Anything found broken in checks 1–3 is in-scope to fix as part of this PRD because the new bindings depend on it; checks 4–5 are pre-conditions, not new work.

**Image clipboard.** `elephant-clipboard-bin` (already installed) is the history backend. Walker's clipboard provider already supports image entries per Omarchy. Verification — does our build surface images in the picker — is a verification step on hardware, not a design point.

**Cut behavior in terminals.** `Mod+X` → `Ctrl+Shift+X` for terminals or `Ctrl+X` for non-terminals. Terminals have no cut concept; the keystroke is sent for symmetry. Most terminals will do nothing useful with it. Intentional, matches Omarchy.

**Mac side.** Out of scope per Solution. `Cmd+C/V/X` is OS-native, Raycast Clipboard History on `Cmd+Ctrl+V` already covers parity. No Mac edits.

**Hyprland (Phase 2b).** Out of scope here. Phase 2b decides whether to reuse `dot-send-shortcut` (consistency) or use Hyprland's native `sendshortcut` (less code). Either choice is compatible with this PRD.

## Testing Decisions

**No automated tests for `dot-send-shortcut`.**

- The `.local/bin/dot-*` fleet has no test harness today (no bats, no shellspec). Adding one for a single ≤30-line script would create a test-infra island.
- The script's surface area is one `niri msg` call, one regex match, one `wtype` invocation. A test would be longer than the implementation.
- Verification happens on the test laptop: install, restart session, exercise each binding in Ghostty (terminal path) and Firefox/Walker/Files (non-terminal path), confirm `Super+Ctrl+V` opens history, confirm Satty image-copy surfaces as an image entry.

**What a good test would look like, if tests are ever added.** Test external behavior — input app_id → output `wtype` argv. Stub `niri msg` and `wtype` to capture invocations. Bats would be the natural choice. Not now.

**Prior art.** `dot-clip-paste-on-select` is the closest analogue and ships untested. Universal clipboard inherits the same verification-by-use convention.

## Out of Scope

- **Cross-device clipboard sync** (Apple's "Universal Clipboard"). Different problem; would need KDE Connect, LocalSend, or similar.
- **macOS-side changes.** `Cmd+C/V/X` and Raycast Clipboard History already cover parity.
- **Debian.** No GUI is installed on Debian per `CONTEXT.md → GUI stack (Arch)`.
- **TTY/console clipboard.** Kernel doesn't see `Super`; consoles use `gpm` or `tmux` for selection.
- **Hyprland.** Phase 2b owns Hyprland keybind work.
- **Full Paneru mirror onto niri.** ADR-0004 captures the philosophy; Phase 2b is the implementation. This PRD only does the surgical relocation needed to free `Mod+C` and `Mod+V` for clipboard.
- **Per-terminal config patches.** Omarchy ships terminal config patches to make F1 work; F2 doesn't need them.
- **`cliphist`.** `elephant-clipboard-bin` already provides history storage.
- **Automated tests.** See Testing Decisions.
- **`dot-clipboard-doctor` diagnostic script.** Brainstorm option 4 was rejected; diagnosis is one-time investigation, not a long-lived artifact.

## Further Notes

- Phase 2d's existing `CONTEXT.md` entry already names "a universal-clipboard implementation to be chosen during 2d scoping" as a deferred member. This PRD is that scoping.
- The eviction homes for displaced niri binds (`Mod+Shift+C` for center-column, `Mod+Ctrl+V` for clipboard history) are stopgaps. Phase 2b's full Paneru port re-homes center-column to `Alt+C` (matching `paneru.toml:76`); `Mod+Ctrl+V` for history sticks because it's the Omarchy canonical chord.
- The `app_id` regex inside `dot-send-shortcut` is the maintenance touchpoint when adopting new terminals. Adding Alacritty / Kitty / Foot / WezTerm to the install is one alternation in one line — no per-app config patches.
- Domain language for this work lives in `CONTEXT.md → Language → Keybinds`.

### Sources consulted

- `~/code/lab/omarchy` — local clone of `basecamp/omarchy`. Source for the universal-clipboard pattern, the per-terminal F1 patches we *aren't* adopting (ghostty/alacritty/kitty Insert binds), and the Hyprland `clipboard.conf` we're translating to niri.
- `~/code/lab/nickjj-dotfiles` — local clone of `nickjj/dotfiles`. Source for `dot-clip-paste-on-select`, the `.config/elephant/clipboard.toml` shape, and the existing `Mod+V` Walker clipboard launcher in niri config.
- `~/.config/paneru/paneru.toml` — user's macOS Paneru WM config. Reference for cross-platform keybind parity (see ADR-0004).

These are durable references for any future work in this repo, not just this PRD.

### Phase 2b transition

When Phase 2b's full Paneru port lands, this PRD's stopgap binds are re-homed:

- `Mod+Shift+C` (center-column stopgap) → `Alt+C`, matching `paneru.toml:76` exactly. Phase 2b deletes the stopgap.
- `Mod+Ctrl+V` (clipboard history) stays. It's the canonical Omarchy chord and survives the WM modifier flip.
- `Mod+C/X/V` (clipboard) stays. Anchored to `Super` per ADR-0004; `Super` becomes the dedicated clipboard modifier post-2b.
- `dot-send-shortcut` either stays in use (niri keeps using it for symmetry with Hyprland's user-facing API) or is bypassed by Hyprland's native `sendshortcut` for the Hyprland half. Phase 2b decides; this PRD doesn't bind that choice.
