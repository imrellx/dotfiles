# imrellx/dotfiles

Personal dotfiles repo re-originated from `nickjj/dotfiles`. Standalone identity; no ongoing git or tooling coupling to the source. Targets Linux (Arch with GUI, Debian, Ubuntu) and macOS.

## Language

### Identity

**Re-origin**:
The act of taking someone else's repo, keeping its git history, and publishing it as a new standalone project under your own identity and remote.
_Avoid_: Fork (implies an upstream sync relationship we don't keep), clone (implies short-lived copy), hard fork.

**Upstream reference**:
`nickjj/dotfiles` as the source this repo was re-originated from. Credited in LICENSE and README. Not tracked as a git remote. Not queried by tooling. Not part of any env var.
_Avoid_: Parent, upstream (as remote name), origin.

**Origin**:
`imrellx/dotfiles` on GitHub. The only remote in `.git/config`.

**Default branch**:
`main` (renamed from upstream's `master`).

### Phases

**Phase 1**:
The re-origin pass. Identity changes (LICENSE, README, FUNDING.yml removal), WSL purge, nickjj-personal strips (SCRIPTS_INSTALL, yarn auto-install, nickjj URLs, nvim YouTube snippet), font swap to IBM Plex Mono Nerd Font, config swaps for `nvim`/`ghostty`/`tmux`, addition of `helix`/`starship`/`sesh`/`superfile`/`vim`/`yazi`/`lazygit`/`mise`/`pi` (packages + configs via mise npm backend for pi), addition of `1password` + `op` CLI, addition of Claude Code via dedicated native-installer function, addition of `_themes/flexoki-dark/` as the default theme.
_Avoid_: MVP, initial commit, v1.

**Phase 2**:
Deferred additions as independent follow-up PRs. Split into two sub-phases that ship in order.
_Avoid_: V2, future work.

**Phase 2a (script import)**:
Arch-Linux-first import of scripts from `/Users/imrellx/code/lab/omarchy/bin`, renamed from `omarchy-*` → `dot-*`, landing in `.local/bin/` alongside the existing `dot-*` fleet. Linux-only; macOS is out of scope; Debian is best-effort per script where the binary equivalents exist. Every source script gets one of three dispositions in the upfront inventory (`docs/prd/0003-*`): `take` (import now), `defer-to-hyprland` (ships with Phase 2b — flagged by any reference to `hyprctl|hypr-|HYPRLAND`, including transitively through cross-script calls), or `skip`. Theme scripts are skipped wholesale because the existing theme indirection layer is authoritative and structurally incompatible with omarchy's per-app model. Update tooling imports primitives only (`update-firmware`, `update-keyring`, `update-system-pkgs`, `update-aur-pkgs`, `update-orphan-pkgs`, `update-time`); the `omarchy-update` orchestrator plus its `omarchy-hook` / `omarchy-state` / `omarchy-show-done` lifecycle web stay out. The `pkg-*` family (`pkg-add`, `pkg-aur-add`, etc.) is imported as a runtime package toolkit under `dot-pkg-*`; it complements the declarative `_install/default/packages/` manifest without competing with it. Collisions with existing niri-native `dot-*` scripts default to niri-native wins.
_Avoid_: phase 2.a, 2.1, scripts phase.

**Phase 2b (Hyprland)**:
Hyprland added as secondary Arch GUI alongside `niri` (not replacing it). The `defer-to-hyprland` scripts from the Phase 2a inventory land with this PR. Scope also includes a keybind-migration strategy: omarchy's Hyprland keybinds reference the deferred scripts, and some of them duplicate niri keybinds for niri-native counterparts — 2b decides whether to mirror, diverge, or share a common subset between the two compositors.
_Avoid_: phase 2.b, 2.2, Hyprland phase.

**Phase 2c (feature bundles)**:
Features that cross into packages + config + keybind + compositor integration — not just script imports. Current known member: VoxType (dictation via `wtype` + `voxtype-bin`, GPU detection via `hw-vulkan`, waybar integration, Hyprland-format keybind that needs niri rewrite). Deferred out of 2a to avoid diluting the 190-script sweep with feature-launch work.
_Avoid_: phase 2.c, 2.3.

**Phase 2d (app additions)**:
Package additions + small configs for apps named in the Phase 2 planning pass but not sourced from omarchy/bin. Known members: Obsidian, Typora, LM Studio, Ollama, GitHub CLI (`gh`), XCompose (config at `~/.XCompose` plus the imported `dot-restart-xcompose` script from 2a), LocalSend (cross-platform file transfer — baseline tier: `localsend-bin` AUR on Arch, GitHub `.deb` + `dpkg -i` on Debian/Ubuntu following the fastfetch pattern at `install:487-491`, `brew install --cask localsend` on macOS — baseline so fresh machines without credentials can receive files before they're otherwise wired up), and a universal-clipboard implementation to be chosen during 2d scoping. Each ships as its own PR with its own install-tier decision (pacman vs AUR vs flatpak vs mise vs brew cask on macOS). Unlike 2a, these are not Linux-only — apps with macOS equivalents get installed there too. The `install-terminal` script from 2a is the mechanism for adding Alacritty or Kitty as a secondary terminal when the user wants one; Wezterm is not in omarchy's supported list and would require a one-line extension to the imported script.
_Avoid_: phase 2.d, 2.4.

### Packaging

**Per-distro native packaging**:
The existing install architecture. Arch uses pacman + AUR, Debian uses apt (with mise fallback for packages not in apt stable), macOS uses brew + brew cask. brew-on-macOS is part of this model; brew-on-Linux is not adopted.
_Avoid_: brew-everywhere, linuxbrew.

**GUI stack (Arch)**:
The Wayland-based tiling WM bundle that ships together on Arch-with-GUI installs: `niri` (compositor), `waybar` (bar), `walker` + `elephant` (launcher + indexer), `mako` (notifications), `satty` (screenshot annotation), `swayidle` (idle management), `uwsm` (session manager), plus `ghostty` (terminal) and `fontconfig`. Managed as one cohesive unit.
_Avoid_: Desktop environment, DE.

### Configs

**Config swap**:
Replace a config directory shipped with the upstream reference with one lifted from `/Users/imrellx/code/personal/ivn-term/config/`. Phase 1 planned swaps: `nvim`, `ghostty`, `tmux`; **actually landed**: `ghostty` only. The Phase 1 `tmux` and `nvim` swaps didn't execute — those configs got theme-indirection hooks added on top of the nickjj base but were never rewritten to the ivn-term base. Landed post-Phase 1: `tmux`, `zsh` (zsh via the reshuffle-in-place variant — see "Zsh swap pattern" below and ADR 0002). Deferred swaps (nickjj wins for now): `btop`, `git`, `nvim`. Each outstanding swap ships as its own follow-up PR; no umbrella phase label. **Swapped configs are modified in-place to honor the theme indirection layer** — hardcoded palette/colorscheme directives are stripped and replaced with `?theme` / `source-file` / theme-plugin-declaration hooks that `set_theme()` can drive. Divergence from ivn-term upstream at swapped files is deliberate; re-merging requires hand-merging the theme hooks.

**Zsh swap pattern (reshuffle-in-place)**:
The zsh swap deliberately does not match the directory-swap shape used for ghostty/tmux. `.config/zsh/` keeps the nickjj scaffold (`.zshrc`, `.zprofile`, `.zshenv`, `.aliases`, plus the install-seeded `.local` override tier) because install-script hooks (`configure_shell()`, `configure_xdg_directories()`) write into those paths. Ivn-term's `config/shell/` content gets lifted alongside as dotted siblings (`.envs`, `.functions`, `.zoptions`, `.inits`); `.zshrc` becomes a thin loader. ADR 0002 captures the Shape A vs Shape B+ trade-off. Future readers should not try to normalize the hybrid shape — install hooks would break.

**Zoxide-sesh coupling**:
`zoxide` is installed as a sesh dependency (sesh's frecent-dirs session picker reads zoxide's database by default), not as a user-facing `z` navigator. No `z` alias is set. `zoxide init` still runs in `.inits` so sesh can query `zoxide query -l`. If a future preference adds interactive `z` use, nothing needs to change — the init already wires `z` / `zi`.

**Config addition**:
Add a new config directory from `ivn-term/config/` for a tool the upstream reference doesn't ship. Phase 1 additions: `helix`, `sesh`, `starship`, `superfile`, `vim`, `yazi`, `lazygit`, `mise`. Skipped: `opencode`, `shell`.

**Starship config path**:
`~/.config/starship/starship.toml` (not the default `~/.config/starship.toml`). Requires `STARSHIP_CONFIG` to be exported from the zsh config.

**Claude Code install tier**:
Claude Code is installed via a dedicated `install_claude_code()` function in the install script, which invokes Anthropic's native `curl https://claude.ai/install.sh | bash -s latest`. Not routed through `MISE_LANGUAGES` (npm backend lags official releases). Idempotent; running the installer on an already-installed system upgrades in place.
_Avoid_: mise task, npm:@anthropic-ai/claude-code.

**Pi (coding agent) install tier**:
Pi is installed via `MISE_LANGUAGES` with the `npm:` backend: `npm:@mariozechner/pi-coding-agent@latest`, keyed as `pi`. Fits the existing mise loop with zero new code.

### Theming

**Theme indirection layer**:
Nickjj's theme-switching architecture, retained and extended. The main config for each themed tool (ghostty, tmux, nvim, btop, fzf, niri, waybar, mako, walker, swaylock, zathura, gtk) references an externally-symlinked theme file. `set_theme()` (install:2010) relinks those files from `_themes/<active>/<file>` to their runtime paths; `dot-theme-set` (`.local/bin/dot-theme-set`) picks which active theme to use.

**Color-scheme dark/light hint**:
`set_theme()` runs `gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"` unconditionally (install:1981, PR #56). This is what libadwaita, Chromium/Electron `prefers-color-scheme`, and xdg-desktop-portal consumers actually read — without it they render light even when GTK is dark. Safe today because every theme under `_themes/` is dark. **TODO if a light variant ever lands**: `set_theme()` must read the theme's mode (e.g., a `mode` file under `_themes/<name>/` or a naming convention like `*-dark` / `*-light`) and emit `prefer-dark` or `prefer-light` accordingly. User preference is dark, so this is a low-priority placeholder, not blocking any current work.

**Flexoki Dark**:
Default active theme in Phase 1. Authored as `_themes/flexoki-dark/` by copying `_themes/tokyonight-moon/` and translating palette values to the Flexoki palette (`#100F0F` bg, `#CECDC3` fg, etc. — full palette sourced from `ivn-term/config/ghostty/config`). GTK portion of the theme is built from `imrellx/Colloid-gtk-theme` (our fork of `vinceliuice/Colloid-gtk-theme`) using a custom `_color-palette-flexoki.scss` + `--tweaks flexoki` scheme; the built theme is hosted as a release asset on the fork and pulled via `install_gui_themes()` like the other two themes.
_Avoid_: Flexoki, flexoki (without the mode suffix — we may add a light variant later).

## Relationships

- **imrellx/dotfiles** retains the full commit history of **nickjj/dotfiles** up to the re-origin point. `git blame` still works. LICENSE attribution matches the commit ancestry.
- Post re-origin, **imrellx/dotfiles** has no git-level or tooling-level coupling to **nickjj/dotfiles**. No `upstream` remote. No `DOTFILES_UPSTREAM_URL`. No `./install --diff`. Pulling ideas happens via ad-hoc `git fetch` + manual inspection.
- **nickjj/dotfiles** is treated as one of several reference sources (alongside `omarchy` and `ivn-term`), not as a privileged parent.
- **Phase 1** changes are mechanical: deletions, renames, three config swaps, eight config additions, one font swap, one package architecture kept as-is. **Phase 2** additions are independent follow-up PRs, each scoped to one tool or theme.
- The **GUI stack (Arch)** is linked via `DEFAULT_CONFIG_INSTALL_GUI_LINUX` (`_install/default/config_install:25–49`). Nothing in Phase 1 changes this tier.
- `CONFIG_INSTALL_GUI_LINUX_EXTRAS` is the user-override tier for adding symlinks on top of the GUI stack defaults. Already empty in this snapshot; no Phase 1 action needed there.

## Flagged ambiguities

- "dotfiles repo" is ambiguous because this repo, `nickjj/dotfiles`, and `ivn-term` are all dotfile-adjacent. Canonical disambiguation: use the full slug when disambiguating — `imrellx/dotfiles`, `nickjj/dotfiles`, `ivn-term`. Unqualified "dotfiles" in repo-internal prose means this repo.
- "teams folder" in project planning notes refers to `_themes/` (Wayland/neovim theme templates: `gruvbox-dark-medium`, `tokyonight-moon`). Verbal slip; no teams concept exists in this repo.
