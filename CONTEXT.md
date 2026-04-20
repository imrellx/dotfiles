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
Deferred additions as independent follow-up PRs. Adds Hyprland as secondary Arch GUI alongside `niri` (not replacing it), imports scripts from `/Users/imrellx/code/lab/omarchy/bin`, and anything else lifted from Omarchy or other sources.
_Avoid_: V2, future work.

### Packaging

**Per-distro native packaging**:
The existing install architecture. Arch uses pacman + AUR, Debian uses apt (with mise fallback for packages not in apt stable), macOS uses brew + brew cask. brew-on-macOS is part of this model; brew-on-Linux is not adopted.
_Avoid_: brew-everywhere, linuxbrew.

**GUI stack (Arch)**:
The Wayland-based tiling WM bundle that ships together on Arch-with-GUI installs: `niri` (compositor), `waybar` (bar), `walker` + `elephant` (launcher + indexer), `mako` (notifications), `satty` (screenshot annotation), `swayidle` (idle management), `uwsm` (session manager), plus `ghostty` (terminal) and `fontconfig`. Managed as one cohesive unit.
_Avoid_: Desktop environment, DE.

### Configs

**Config swap**:
Replace a config directory shipped with the upstream reference with one lifted from `/Users/imrellx/code/personal/ivn-term/config/`. Phase 1 swaps: `nvim`, `ghostty`, `tmux`. Deferred swaps (nickjj wins for now): `btop`, `git`, `zsh`. **Swapped configs are modified in-place to honor the theme indirection layer** — hardcoded palette/colorscheme directives are stripped and replaced with `?theme` / `source-file` / theme-plugin-declaration hooks that `set_theme()` can drive. Divergence from ivn-term upstream at these three files is deliberate; re-merging requires hand-merging the theme hooks.

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

**Flexoki Dark**:
Default active theme in Phase 1. Authored as `_themes/flexoki-dark/` by copying `_themes/tokyonight-moon/` and translating palette values to the Flexoki palette (`#100F0F` bg, `#CECDC3` fg, etc. — full palette sourced from `ivn-term/config/ghostty/config`).
_Avoid_: Flexoki, flexoki (without the mode suffix — we may add a light variant in Phase 2).

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
- ".mnt folder needs to go into the etc folder" in project planning notes was a dictation slip. Canonical reading: both `mnt/` and `etc/wsl.conf` are **deleted**, not moved.
- "WSL.com" in project planning notes refers to `etc/wsl.conf`. Dictation slip.
