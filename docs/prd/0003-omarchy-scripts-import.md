# Omarchy scripts import: inventory and slice plan

Companion reference doc to GitHub issue [#36](https://github.com/imrellx/dotfiles/issues/36) (the Phase 2a PRD). Where #36 is the proposal and user-facing narrative, this doc is the triage artifact — the per-script classification table that slice PRs cite.

## Purpose

Classify every script in `omarchy/bin` exactly once, so slice PRs don't relitigate "what about `omarchy-hw-surface`?" per review. The rubric and reasons are recorded so a future pass can re-triage when omarchy evolves without starting from scratch.

## Source pin

- Upstream: `/Users/imrellx/code/lab/omarchy` (not a git remote — ad-hoc `git fetch` per ADR-0001)
- Commit classified: `8912bcb81c4f3a3cc929f71c658b700846ff0c06` (2026-04-17, "Add mako restart to Update > Process")
- Script count at classification: 214

## Dispositions

| Label | Meaning |
|---|---|
| `take` | Import in Phase 2a. Renamed `omarchy-*` → `dot-*`. Lands in `.local/bin/`. |
| `defer-to-2b` | Ships with the Phase 2b Hyprland PR. Hyprland-coupled directly or transitively. |
| `defer-to-2c` | Ships with the Phase 2c VoxType feature bundle (packages + config + keybind + waybar wiring). |
| `skip` | Not imported. Theme scripts, update orchestrator, lifecycle, user-rejected opt-in installers. |

## Rubric

Applied in order; first match wins:

1. Script name starts with `omarchy-voxtype-` → `defer-to-2c`
2. Script body matches `grep -E "hyprctl|hypr-|HYPRLAND"` (after stripping comments and quoted strings) → `defer-to-2b` (direct)
3. Script transitively calls any script in rule 2 via cross-refs → `defer-to-2b` (transitive)
4. Script name starts with `omarchy-theme-` → `skip` (theme family incompatible with existing `set_theme()` layer — see CONTEXT.md "Theming")
5. Script is in the user-rejected opt-in installer set → `skip`
6. Script is in the omarchy-repo lifecycle set → `skip`
7. Script is in the update-orchestrator set (primitives taken; orchestrator dropped per CONTEXT.md "Phase 2a") → `skip`
8. Otherwise → `take`

The cross-ref regex for transitive closure: `omarchy-[a-z0-9-]+`, applied after comment + quoted-string stripping. String stripping matters — several scripts mention sibling scripts in comments or curl user-agent strings, which would otherwise produce false-positive defer edges.

## Totals

| Disposition | Count |
|---|---:|
| `take` | 119 |
| `defer-to-2b` | 45 |
| `defer-to-2c` | 5 |
| `skip` | 45 |
| **Total** | **214** |

## Inventory

| # | Source script | Disposition | Target name | Reason |
|--:|---|---|---|---|
| 1 | `omarchy-ac-present` | `take` | `dot-ac-present` | compositor-neutral utility |
| 2 | `omarchy-battery-capacity` | `take` | `dot-battery-capacity` | compositor-neutral utility |
| 3 | `omarchy-battery-monitor` | `take` | `dot-battery-monitor` | compositor-neutral utility |
| 4 | `omarchy-battery-present` | `take` | `dot-battery-present` | compositor-neutral utility |
| 5 | `omarchy-battery-remaining` | `take` | `dot-battery-remaining` | compositor-neutral utility |
| 6 | `omarchy-battery-remaining-time` | `take` | `dot-battery-remaining-time` | compositor-neutral utility |
| 7 | `omarchy-battery-status` | `take` | `dot-battery-status` | compositor-neutral utility |
| 8 | `omarchy-branch-set` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 9 | `omarchy-brightness-display` | `take` | `dot-brightness-display` | compositor-neutral utility |
| 10 | `omarchy-brightness-display-apple` | `take` | `dot-brightness-display-apple` | compositor-neutral utility |
| 11 | `omarchy-brightness-keyboard` | `take` | `dot-brightness-keyboard` | compositor-neutral utility |
| 12 | `omarchy-channel-set` | `defer-to-2b` | `—` | transitive: omarchy-update → omarchy-update-git |
| 13 | `omarchy-cmd-audio-switch` | `defer-to-2b` | `—` | transitive: omarchy-hyprland-monitor-focused |
| 14 | `omarchy-cmd-first-run` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 15 | `omarchy-cmd-mic-mute` | `take` | `dot-cmd-mic-mute` | compositor-neutral utility |
| 16 | `omarchy-cmd-mic-mute-xps` | `take` | `dot-cmd-mic-mute-xps` | compositor-neutral utility |
| 17 | `omarchy-cmd-missing` | `take` | `dot-cmd-missing` | compositor-neutral utility |
| 18 | `omarchy-cmd-present` | `take` | `dot-cmd-present` | compositor-neutral utility |
| 19 | `omarchy-cmd-screenrecord` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 20 | `omarchy-cmd-screensaver` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 21 | `omarchy-cmd-screenshot` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 22 | `omarchy-cmd-share` | `take` | `dot-cmd-share` | compositor-neutral utility |
| 23 | `omarchy-cmd-terminal-cwd` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 24 | `omarchy-config-direct-boot` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 25 | `omarchy-debug` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 26 | `omarchy-dev-add-migration` | `take` | `dot-dev-add-migration` | compositor-neutral utility |
| 27 | `omarchy-drive-info` | `take` | `dot-drive-info` | compositor-neutral utility |
| 28 | `omarchy-drive-select` | `take` | `dot-drive-select` | compositor-neutral utility |
| 29 | `omarchy-drive-set-password` | `take` | `dot-drive-set-password` | compositor-neutral utility |
| 30 | `omarchy-font-current` | `take` | `dot-font-current` | compositor-neutral utility |
| 31 | `omarchy-font-list` | `take` | `dot-font-list` | compositor-neutral utility |
| 32 | `omarchy-font-set` | `take` | `dot-font-set` | compositor-neutral utility |
| 33 | `omarchy-haptic-touchpad` | `take` | `dot-haptic-touchpad` | compositor-neutral utility |
| 34 | `omarchy-hibernation-available` | `take` | `dot-hibernation-available` | compositor-neutral utility |
| 35 | `omarchy-hibernation-remove` | `take` | `dot-hibernation-remove` | compositor-neutral utility |
| 36 | `omarchy-hibernation-setup` | `defer-to-2b` | `—` | transitive: omarchy-system-reboot → omarchy-hyprland-window-close-all |
| 37 | `omarchy-hook` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 38 | `omarchy-hw-asus-rog` | `take` | `dot-hw-asus-rog` | compositor-neutral utility |
| 39 | `omarchy-hw-dell-xps-oled` | `take` | `dot-hw-dell-xps-oled` | compositor-neutral utility |
| 40 | `omarchy-hw-framework16` | `take` | `dot-hw-framework16` | compositor-neutral utility |
| 41 | `omarchy-hw-intel` | `take` | `dot-hw-intel` | compositor-neutral utility |
| 42 | `omarchy-hw-intel-ptl` | `take` | `dot-hw-intel-ptl` | compositor-neutral utility |
| 43 | `omarchy-hw-match` | `take` | `dot-hw-match` | compositor-neutral utility |
| 44 | `omarchy-hw-surface` | `take` | `dot-hw-surface` | compositor-neutral utility |
| 45 | `omarchy-hw-vulkan` | `take` | `dot-hw-vulkan` | compositor-neutral utility |
| 46 | `omarchy-hyprland-active-window-transparency-toggle` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 47 | `omarchy-hyprland-monitor-focused` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 48 | `omarchy-hyprland-monitor-internal-toggle` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 49 | `omarchy-hyprland-monitor-scaling-cycle` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 50 | `omarchy-hyprland-window-close-all` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 51 | `omarchy-hyprland-window-gaps-toggle` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 52 | `omarchy-hyprland-window-pop` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 53 | `omarchy-hyprland-window-single-square-aspect-toggle` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 54 | `omarchy-hyprland-workspace-layout-toggle` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 55 | `omarchy-install-chromium-google-account` | `take` | `dot-install-chromium-google-account` | compositor-neutral utility |
| 56 | `omarchy-install-dev-env` | `skip` | `—` | opt-in installer, user rejected |
| 57 | `omarchy-install-docker-dbs` | `take` | `dot-install-docker-dbs` | compositor-neutral utility |
| 58 | `omarchy-install-dropbox` | `take` | `dot-install-dropbox` | compositor-neutral utility |
| 59 | `omarchy-install-geforce-now` | `skip` | `—` | opt-in installer, user rejected |
| 60 | `omarchy-install-nordvpn` | `defer-to-2b` | `—` | transitive: omarchy-system-reboot → omarchy-hyprland-window-close-all |
| 61 | `omarchy-install-once` | `take` | `dot-install-once` | compositor-neutral utility |
| 62 | `omarchy-install-steam` | `skip` | `—` | opt-in installer, user rejected |
| 63 | `omarchy-install-tailscale` | `take` | `dot-install-tailscale` | compositor-neutral utility |
| 64 | `omarchy-install-terminal` | `take` | `dot-install-terminal` | compositor-neutral utility |
| 65 | `omarchy-install-vscode` | `take` | `dot-install-vscode` | compositor-neutral utility |
| 66 | `omarchy-install-xbox-controllers` | `skip` | `—` | opt-in installer, user rejected |
| 67 | `omarchy-launch-about` | `defer-to-2b` | `—` | transitive: omarchy-launch-or-focus-tui → omarchy-launch-or-focus |
| 68 | `omarchy-launch-audio` | `defer-to-2b` | `—` | transitive: omarchy-launch-or-focus-tui → omarchy-launch-or-focus |
| 69 | `omarchy-launch-bluetooth` | `defer-to-2b` | `—` | transitive: omarchy-launch-or-focus-tui → omarchy-launch-or-focus |
| 70 | `omarchy-launch-browser` | `take` | `dot-launch-browser` | compositor-neutral utility |
| 71 | `omarchy-launch-editor` | `take` | `dot-launch-editor` | compositor-neutral utility |
| 72 | `omarchy-launch-floating-terminal-with-presentation` | `take` | `dot-launch-floating-terminal-with-presentation` | compositor-neutral utility |
| 73 | `omarchy-launch-or-focus` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 74 | `omarchy-launch-or-focus-tui` | `defer-to-2b` | `—` | transitive: omarchy-launch-or-focus |
| 75 | `omarchy-launch-or-focus-webapp` | `defer-to-2b` | `—` | transitive: omarchy-launch-or-focus |
| 76 | `omarchy-launch-screensaver` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 77 | `omarchy-launch-tui` | `take` | `dot-launch-tui` | compositor-neutral utility |
| 78 | `omarchy-launch-walker` | `take` | `dot-launch-walker` | compositor-neutral utility |
| 79 | `omarchy-launch-webapp` | `take` | `dot-launch-webapp` | compositor-neutral utility |
| 80 | `omarchy-launch-wifi` | `defer-to-2b` | `—` | transitive: omarchy-launch-or-focus-tui → omarchy-launch-or-focus |
| 81 | `omarchy-lock-screen` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 82 | `omarchy-menu` | `defer-to-2b` | `—` | transitive: omarchy-cmd-screenrecord |
| 83 | `omarchy-menu-keybindings` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 84 | `omarchy-migrate` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 85 | `omarchy-notification-dismiss` | `take` | `dot-notification-dismiss` | compositor-neutral utility |
| 86 | `omarchy-npx-install` | `take` | `dot-npx-install` | compositor-neutral utility |
| 87 | `omarchy-pkg-add` | `take` | `dot-pkg-add` | compositor-neutral utility |
| 88 | `omarchy-pkg-aur-accessible` | `take` | `dot-pkg-aur-accessible` | compositor-neutral utility |
| 89 | `omarchy-pkg-aur-add` | `take` | `dot-pkg-aur-add` | compositor-neutral utility |
| 90 | `omarchy-pkg-aur-install` | `take` | `dot-pkg-aur-install` | compositor-neutral utility |
| 91 | `omarchy-pkg-drop` | `take` | `dot-pkg-drop` | compositor-neutral utility |
| 92 | `omarchy-pkg-install` | `take` | `dot-pkg-install` | compositor-neutral utility |
| 93 | `omarchy-pkg-missing` | `take` | `dot-pkg-missing` | compositor-neutral utility |
| 94 | `omarchy-pkg-present` | `take` | `dot-pkg-present` | compositor-neutral utility |
| 95 | `omarchy-pkg-remove` | `take` | `dot-pkg-remove` | compositor-neutral utility |
| 96 | `omarchy-powerprofiles-init` | `take` | `dot-powerprofiles-init` | compositor-neutral utility |
| 97 | `omarchy-powerprofiles-list` | `take` | `dot-powerprofiles-list` | compositor-neutral utility |
| 98 | `omarchy-powerprofiles-set` | `take` | `dot-powerprofiles-set` | compositor-neutral utility |
| 99 | `omarchy-refresh-applications` | `take` | `dot-refresh-applications` | compositor-neutral utility |
| 100 | `omarchy-refresh-chromium` | `take` | `dot-refresh-chromium` | compositor-neutral utility |
| 101 | `omarchy-refresh-config` | `take` | `dot-refresh-config` | compositor-neutral utility |
| 102 | `omarchy-refresh-fastfetch` | `take` | `dot-refresh-fastfetch` | compositor-neutral utility |
| 103 | `omarchy-refresh-hypridle` | `take` | `dot-refresh-hypridle` | compositor-neutral utility |
| 104 | `omarchy-refresh-hyprland` | `take` | `dot-refresh-hyprland` | compositor-neutral utility |
| 105 | `omarchy-refresh-hyprlock` | `take` | `dot-refresh-hyprlock` | compositor-neutral utility |
| 106 | `omarchy-refresh-hyprsunset` | `take` | `dot-refresh-hyprsunset` | compositor-neutral utility |
| 107 | `omarchy-refresh-limine` | `take` | `dot-refresh-limine` | compositor-neutral utility |
| 108 | `omarchy-refresh-pacman` | `take` | `dot-refresh-pacman` | compositor-neutral utility |
| 109 | `omarchy-refresh-plymouth` | `take` | `dot-refresh-plymouth` | compositor-neutral utility |
| 110 | `omarchy-refresh-sddm` | `take` | `dot-refresh-sddm` | compositor-neutral utility |
| 111 | `omarchy-refresh-swayosd` | `take` | `dot-refresh-swayosd` | compositor-neutral utility |
| 112 | `omarchy-refresh-tmux` | `take` | `dot-refresh-tmux` | compositor-neutral utility |
| 113 | `omarchy-refresh-walker` | `take` | `dot-refresh-walker` | compositor-neutral utility |
| 114 | `omarchy-refresh-waybar` | `take` | `dot-refresh-waybar` | compositor-neutral utility |
| 115 | `omarchy-reinstall` | `defer-to-2b` | `—` | transitive: omarchy-system-reboot → omarchy-hyprland-window-close-all |
| 116 | `omarchy-reinstall-configs` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 117 | `omarchy-reinstall-git` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 118 | `omarchy-reinstall-pkgs` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 119 | `omarchy-remove-dev-env` | `take` | `dot-remove-dev-env` | compositor-neutral utility |
| 120 | `omarchy-remove-preinstalls` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 121 | `omarchy-restart-app` | `take` | `dot-restart-app` | compositor-neutral utility |
| 122 | `omarchy-restart-bluetooth` | `take` | `dot-restart-bluetooth` | compositor-neutral utility |
| 123 | `omarchy-restart-btop` | `take` | `dot-restart-btop` | compositor-neutral utility |
| 124 | `omarchy-restart-hyprctl` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 125 | `omarchy-restart-hypridle` | `take` | `dot-restart-hypridle` | compositor-neutral utility |
| 126 | `omarchy-restart-hyprsunset` | `take` | `dot-restart-hyprsunset` | compositor-neutral utility |
| 127 | `omarchy-restart-mako` | `take` | `dot-restart-mako` | compositor-neutral utility |
| 128 | `omarchy-restart-opencode` | `take` | `dot-restart-opencode` | compositor-neutral utility |
| 129 | `omarchy-restart-pipewire` | `take` | `dot-restart-pipewire` | compositor-neutral utility |
| 130 | `omarchy-restart-swayosd` | `take` | `dot-restart-swayosd` | compositor-neutral utility |
| 131 | `omarchy-restart-terminal` | `take` | `dot-restart-terminal` | compositor-neutral utility |
| 132 | `omarchy-restart-tmux` | `take` | `dot-restart-tmux` | compositor-neutral utility |
| 133 | `omarchy-restart-trackpad` | `take` | `dot-restart-trackpad` | compositor-neutral utility |
| 134 | `omarchy-restart-walker` | `take` | `dot-restart-walker` | compositor-neutral utility |
| 135 | `omarchy-restart-waybar` | `take` | `dot-restart-waybar` | compositor-neutral utility |
| 136 | `omarchy-restart-wifi` | `take` | `dot-restart-wifi` | compositor-neutral utility |
| 137 | `omarchy-restart-xcompose` | `take` | `dot-restart-xcompose` | compositor-neutral utility |
| 138 | `omarchy-setup-dns` | `take` | `dot-setup-dns` | compositor-neutral utility |
| 139 | `omarchy-setup-fido2` | `take` | `dot-setup-fido2` | compositor-neutral utility |
| 140 | `omarchy-setup-fingerprint` | `take` | `dot-setup-fingerprint` | compositor-neutral utility |
| 141 | `omarchy-show-done` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 142 | `omarchy-show-logo` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 143 | `omarchy-snapshot` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 144 | `omarchy-state` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 145 | `omarchy-sudo-keepalive` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 146 | `omarchy-sudo-passwordless-toggle` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 147 | `omarchy-sudo-reset` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 148 | `omarchy-swayosd-brightness` | `take` | `dot-swayosd-brightness` | compositor-neutral utility |
| 149 | `omarchy-swayosd-kbd-brightness` | `take` | `dot-swayosd-kbd-brightness` | compositor-neutral utility |
| 150 | `omarchy-system-logout` | `defer-to-2b` | `—` | transitive: omarchy-hyprland-window-close-all |
| 151 | `omarchy-system-reboot` | `defer-to-2b` | `—` | transitive: omarchy-hyprland-window-close-all |
| 152 | `omarchy-system-shutdown` | `defer-to-2b` | `—` | transitive: omarchy-hyprland-window-close-all |
| 153 | `omarchy-theme-bg-install` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 154 | `omarchy-theme-bg-next` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 155 | `omarchy-theme-bg-set` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 156 | `omarchy-theme-current` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 157 | `omarchy-theme-install` | `defer-to-2b` | `—` | transitive: omarchy-theme-set |
| 158 | `omarchy-theme-list` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 159 | `omarchy-theme-refresh` | `defer-to-2b` | `—` | transitive: omarchy-theme-set |
| 160 | `omarchy-theme-remove` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 161 | `omarchy-theme-set` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 162 | `omarchy-theme-set-browser` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 163 | `omarchy-theme-set-gnome` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 164 | `omarchy-theme-set-keyboard` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 165 | `omarchy-theme-set-keyboard-asus-rog` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 166 | `omarchy-theme-set-keyboard-f16` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 167 | `omarchy-theme-set-obsidian` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 168 | `omarchy-theme-set-templates` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 169 | `omarchy-theme-set-vscode` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 170 | `omarchy-theme-update` | `skip` | `—` | theme scripts skipped wholesale (see CONTEXT.md) |
| 171 | `omarchy-toggle-hybrid-gpu` | `defer-to-2b` | `—` | transitive: omarchy-system-reboot → omarchy-hyprland-window-close-all |
| 172 | `omarchy-toggle-idle` | `take` | `dot-toggle-idle` | compositor-neutral utility |
| 173 | `omarchy-toggle-nightlight` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 174 | `omarchy-toggle-notification-silencing` | `take` | `dot-toggle-notification-silencing` | compositor-neutral utility |
| 175 | `omarchy-toggle-screensaver` | `take` | `dot-toggle-screensaver` | compositor-neutral utility |
| 176 | `omarchy-toggle-suspend` | `take` | `dot-toggle-suspend` | compositor-neutral utility |
| 177 | `omarchy-toggle-waybar` | `take` | `dot-toggle-waybar` | compositor-neutral utility |
| 178 | `omarchy-tui-install` | `take` | `dot-tui-install` | compositor-neutral utility |
| 179 | `omarchy-tui-remove` | `take` | `dot-tui-remove` | compositor-neutral utility |
| 180 | `omarchy-tui-remove-all` | `take` | `dot-tui-remove-all` | compositor-neutral utility |
| 181 | `omarchy-tz-select` | `take` | `dot-tz-select` | compositor-neutral utility |
| 182 | `omarchy-update` | `defer-to-2b` | `—` | transitive: omarchy-update-git |
| 183 | `omarchy-update-analyze-logs` | `skip` | `—` | update orchestrator; primitives taken separately |
| 184 | `omarchy-update-aur-pkgs` | `take` | `dot-update-aur-pkgs` | compositor-neutral utility |
| 185 | `omarchy-update-available` | `skip` | `—` | update orchestrator; primitives taken separately |
| 186 | `omarchy-update-available-reset` | `skip` | `—` | update orchestrator; primitives taken separately |
| 187 | `omarchy-update-branch` | `defer-to-2b` | `—` | transitive: omarchy-update-perform |
| 188 | `omarchy-update-confirm` | `skip` | `—` | update orchestrator; primitives taken separately |
| 189 | `omarchy-update-firmware` | `take` | `dot-update-firmware` | compositor-neutral utility |
| 190 | `omarchy-update-git` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 191 | `omarchy-update-keyring` | `take` | `dot-update-keyring` | compositor-neutral utility |
| 192 | `omarchy-update-orphan-pkgs` | `take` | `dot-update-orphan-pkgs` | compositor-neutral utility |
| 193 | `omarchy-update-perform` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |
| 194 | `omarchy-update-restart` | `defer-to-2b` | `—` | transitive: omarchy-system-reboot → omarchy-hyprland-window-close-all |
| 195 | `omarchy-update-system-pkgs` | `take` | `dot-update-system-pkgs` | compositor-neutral utility |
| 196 | `omarchy-update-time` | `take` | `dot-update-time` | compositor-neutral utility |
| 197 | `omarchy-update-without-idle` | `skip` | `—` | update orchestrator; primitives taken separately |
| 198 | `omarchy-upload-log` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 199 | `omarchy-version` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 200 | `omarchy-version-branch` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 201 | `omarchy-version-channel` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 202 | `omarchy-version-pkgs` | `skip` | `—` | omarchy-repo lifecycle, not applicable |
| 203 | `omarchy-voxtype-config` | `defer-to-2c` | `—` | VoxType feature bundle deferred to Phase 2c |
| 204 | `omarchy-voxtype-install` | `defer-to-2c` | `—` | VoxType feature bundle deferred to Phase 2c |
| 205 | `omarchy-voxtype-model` | `defer-to-2c` | `—` | VoxType feature bundle deferred to Phase 2c |
| 206 | `omarchy-voxtype-remove` | `defer-to-2c` | `—` | VoxType feature bundle deferred to Phase 2c |
| 207 | `omarchy-voxtype-status` | `defer-to-2c` | `—` | VoxType feature bundle deferred to Phase 2c |
| 208 | `omarchy-webapp-handler-hey` | `take` | `dot-webapp-handler-hey` | compositor-neutral utility |
| 209 | `omarchy-webapp-handler-zoom` | `take` | `dot-webapp-handler-zoom` | compositor-neutral utility |
| 210 | `omarchy-webapp-install` | `take` | `dot-webapp-install` | compositor-neutral utility |
| 211 | `omarchy-webapp-remove` | `take` | `dot-webapp-remove` | compositor-neutral utility |
| 212 | `omarchy-webapp-remove-all` | `take` | `dot-webapp-remove-all` | compositor-neutral utility |
| 213 | `omarchy-wifi-powersave` | `take` | `dot-wifi-powersave` | compositor-neutral utility |
| 214 | `omarchy-windows-vm` | `defer-to-2b` | `—` | direct hyprctl/HYPRLAND coupling |

## Slice PR plan

The `take` set (119 scripts) ships across 9 category-scoped slice PRs. Order is advisory — dependencies within the `take` set are loose enough that rearrangement is cheap. Each PR cites the inventory rows it lands.

| # | Slice | Contents | Depends on |
|--:|---|---|---|
| 1 | `pkg-*` runtime toolkit + `install-once` | `dot-pkg-add`, `dot-pkg-drop`, `dot-pkg-install`, `dot-pkg-remove`, `dot-pkg-missing`, `dot-pkg-present`, `dot-pkg-aur-add`, `dot-pkg-aur-install`, `dot-pkg-aur-accessible`, `dot-install-once` | — |
| 2 | Hardware family + system update primitives | `dot-hw-*` (all 8), `dot-update-firmware`, `dot-update-keyring`, `dot-update-system-pkgs`, `dot-update-aur-pkgs`, `dot-update-orphan-pkgs`, `dot-update-time` | slice 1 |
| 3 | Battery / brightness / AC / drive / hibernation primitives | `dot-ac-*`, `dot-battery-*`, `dot-drive-*`, `dot-hibernation-*` (minus Hyprland-coupled) | slice 1 |
| 4 | Restart family (compositor-neutral only) | `dot-restart-waybar`, `-mako`, `-walker`, `-pipewire`, `-swayosd`, `-trackpad`, `-wifi`, `-bluetooth`, `-terminal`, `-tmux`, `-btop`, `-opencode`, `-xcompose`, `-app` | — |
| 5 | Setup family | `dot-setup-fingerprint`, `dot-setup-dns`, `dot-setup-fido2` | slice 1 |
| 6 | Launch family (compositor-neutral) | `dot-launch-browser`, `dot-launch-editor`, `dot-launch-walker`, `dot-launch-floating-terminal-with-presentation`, `dot-launch-webapp` | — |
| 7 | Webapp bundle | `dot-webapp-install`, `-remove`, `-remove-all`, `-handler-hey`, `-handler-zoom` | slice 6 |
| 8 | TUI bundle + niri window rules | `dot-tui-install`, `-remove`, `-remove-all`, `dot-launch-tui`; niri config rule for `app-id=TUI.float` and `app-id=TUI.tile` | — |
| 9 | Opt-in install apps | `dot-install-chromium-google-account`, `-docker-dbs`, `-dropbox`, `-tailscale`, `-terminal`, `-vscode` | slice 1 |

Scripts in `take` that don't cleanly fit a slice above land in the closest neighbour; exact placement decided at slice-authoring time.

## Collisions and special cases

### `dot-menu` (collision — auto-resolved)

Your `.local/bin/dot-menu` is a minimal walker-driven system menu (lock/suspend/logout/reboot/shutdown). `omarchy-menu` is a nested submenu orchestrator. After the rubric, `omarchy-menu` transitively defers to 2b (via `omarchy-menu-keybindings` which hits `HYPRLAND`). So no collision to resolve in 2a.

When Phase 2b lands, `omarchy-menu` will be in scope. Decision point at that time: adopt omarchy's nested menu and retire `dot-menu`, keep both (rename omarchy's), or skip omarchy's (niri-native wins). No pre-commitment here.

### `dot-launch-or-focus` and `dot-launch-or-focus-tui` (collisions — auto-resolved)

Both have existing niri-native `.local/bin/dot-*` implementations using `niri msg`. The omarchy-origin versions use `hyprctl` and defer to 2b directly or transitively. Niri versions stay authoritative on niri; Hyprland versions will coexist under different compositor context when 2b lands. Phase 2b may need a small runtime dispatch (e.g., pick implementation based on `$XDG_SESSION_TYPE` or active compositor) — flagged for 2b design, not 2a.

### `dot-theme-set` and `dot-theme-set-bg` (collisions — auto-resolved by skip)

Both existing niri-based scripts stay. All omarchy `theme-*` scripts skip wholesale per rubric.

## Supporting files import

Some `take` scripts reference files under `$OMARCHY_PATH/applications/` or `$OMARCHY_PATH/default/`. These files need to come along for the imported script to work:

| Script | Referenced file | Import target |
|---|---|---|
| `dot-install-terminal` | `applications/Alacritty.desktop` | `.local/share/applications/` (at install time) or seed in repo |
| `dot-webapp-install` | — | (no static file — runtime favicon fetch) |
| `dot-launch-webapp` | — | (no static file) |
| `dot-install-chromium-google-account` | potentially desktop-entry template | verify at slice 9 authoring |

Full supporting-files audit happens per slice PR, not here. Placement pattern (folded into existing `.config/` vs. a new `_omarchy/` staging dir) decided during slice 1 authoring and then followed for the rest.

## `$OMARCHY_PATH` rewrite

Every imported script with `$OMARCHY_PATH` gets rewritten at import time:

- `$OMARCHY_PATH/applications/*.desktop` → `$DOTFILES_PATH/<imported-path>/*.desktop` (import the file too)
- `$OMARCHY_PATH/default/<tool>/config.toml` → inline or import the file into `.config/<tool>/`
- `$OMARCHY_PATH` bare references → `$DOTFILES_PATH` where semantically equivalent

Tracked per-script at slice-authoring time; no central rewrite table needed.

## Re-triage workflow

When omarchy evolves and you want to re-sync:

1. `git -C /Users/imrellx/code/lab/omarchy fetch && git -C /Users/imrellx/code/lab/omarchy log <old-sha>..HEAD -- bin/` — list changes to `bin/` since last classification
2. For each new/modified script: apply the rubric from the "Rubric" section above
3. Update this doc — bump the source pin, adjust rows, update totals
4. Slice PRs follow for the newly-`take`d scripts (or retractions)

The rubric is designed to be reapplied, not re-derived.

## References

- PRD issue: [#36 Phase 2a: Import omarchy scripts under dot-* prefix](https://github.com/imrellx/dotfiles/issues/36)
- CONTEXT.md sections: "Phases" (2a/2b/2c/2d definitions), "Theming" (theme indirection layer rationale)
- ADR-0001: re-origin-without-upstream-tooling (why omarchy is not tracked as a remote)
- ADR-0003 (forthcoming): omarchy-scripts-rename-to-dot-prefix

## Open items and deferred investigations

Surfaced during the audit pass (post-draft). None of these change the 214-row classification or the slice plan; they are unresolved items the original planning conversation raised but did not close.

### Omarchy manual links not yet reviewed

Five pages from the omarchy manual were cited during Phase 2 planning but never fetched. Content there may refine 2d scoping — especially universal clipboard (implementation not yet chosen) and navigation/hotkey conventions. Review before authoring Phase 2d PRs, not before 2a slice PRs (2a is independent).

- `learn.omacom.io/2/the-omarchy-manual/59/tuis` — relevant to slice 8 niri window-rule design and Phase 2d navigation keybinds
- `learn.omacom.io/2/the-omarchy-manual/57/shell-tools` — shell-tool conventions; FZF/zoxide/ripgrep/fd already installed, this may surface additions
- `learn.omacom.io/2/the-omarchy-manual/53/hotkeys` — omarchy's hotkey reference; input to Phase 2b keybind strategy
- `learn.omacom.io/2/the-omarchy-manual/105/universal-clipboard` — names omarchy's universal-clipboard choice; drives Phase 2d implementation selection
- `learn.omacom.io/2/the-omarchy-manual/51/navigation` — navigation keybind conventions; Phase 2b or 2d input

### Phase 2b keybind strategy

Phase 2b imports ~45 deferred scripts that omarchy originally wires to Hyprland keybinds. Several of those scripts collide by name with niri-native `dot-*` implementations that already have niri keybinds. 2b needs a decision framework: mirror the omarchy keybinds under Hyprland (and keep niri's separate), unify a common subset between the two compositors, or diverge deliberately. Deferred to 2b authoring. Captured in CONTEXT.md Phase 2b entry.

### Phase 2d universal-clipboard implementation

Phase 2d lists universal clipboard as a member but does not pick a tool. Omarchy documents its choice in the manual (link above). Action: fetch that page, verify the tool is macOS-compatible (this 2d member crosses platforms), then pick — or deliberately diverge.

### Phase 2d wezterm addition

User named wezterm as a possible terminal fallback alongside alacritty. `dot-install-terminal` imported in slice 9 supports alacritty/ghostty/kitty only. If wezterm is wanted, a one-line case arm addition goes into either slice 9 or a follow-up 2d PR. Decision deferred until the user confirms wezterm is a real want versus a brainstorm mention.

### Phase 2d Obsidian/Typora theming

CONTEXT.md Phase 2a skips all theme-family scripts, including `omarchy-theme-set-obsidian` and `omarchy-theme-set-vscode`. When Phase 2d lands Obsidian or VSCode, the theming story returns — either extend `set_theme()` in `install` with app-specific hooks, or lift the skipped omarchy setters at that point. Deferred to 2d authoring.

### Phase 2a Wi-Fi launcher visibility

`omarchy-launch-wifi` is classified `defer-to-2b` (transitive: it calls `launch-or-focus-tui` → `launch-or-focus` → hyprctl). The user named Wi-Fi launching as a want during planning. No 2a substitute is provided; on niri, Wi-Fi is managed outside the script family (via `nmcli`, `iwctl`, or waybar's network module). If a niri-native `dot-launch-wifi` is wanted before Phase 2b, it is a small follow-up — not blocking 2a.
