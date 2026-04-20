# Phase 1 — Re-origin from nickjj/dotfiles

## Problem Statement

I maintain a working copy of `nickjj/dotfiles`, but it's not mine. The repo still advertises nickjj's identity (LICENSE, README, FUNDING.yml, Sponsor button), carries WSL support I'll never use, references nickjj-specific infrastructure (personal scripts, private storage paths, YouTube-description snippets, a hardcoded `upstream` git remote), uses a font I've replaced, and ships a theme palette that isn't mine. Every fresh install also pulls curl-bash scripts from nickjj's personal GitHub that I don't run.

I want the repo to be unambiguously mine — my identity, my tools, my theme, my install story — while keeping the architectural spine (three-OS installer, theme indirection, config symlinking) that I've found works well. I do not want to fork-and-sync with nickjj; I want a clean re-origin that credits the source but owns its own future.

## Solution

A single-phase re-origin commit pass that transforms this clone into a standalone `imrellx/dotfiles` project with its own identity, its own tool inventory, and its own default theme, while preserving the git history that makes `git blame` useful.

The re-origin removes everything nickjj-personal (WSL, personal scripts, personal URLs, personal theme defaults, personal sponsor links), replaces the font and default theme with Flexoki Dark, swaps three tool configs (nvim, ghostty, tmux) to my curated versions from `ivn-term`, adds eight new tools I rely on daily (helix, starship, sesh, superfile, vim, yazi, lazygit, mise tool-plus), adds 1Password (GUI + CLI) across all three OSes, and adds Claude Code via the official native installer. The install architecture (per-distro native package managers, `./install` as single entry point, theme symlink indirection) stays intact — this is a content change, not an architectural change.

Post-Phase-1, the repo works on Arch (with GUI), Debian, Ubuntu, and macOS. WSL is unsupported. Phase 2 will add Hyprland alongside niri, import Omarchy scripts, and optionally migrate to a mise-config-driven install paradigm.

## User Stories

1. As the repo owner, I want the LICENSE to credit both nickjj (2018) and me (2026), so that MIT attribution is preserved while the repo is clearly mine.
2. As the repo owner, I want the README to open with "Based on nickjj/dotfiles" and otherwise speak in a neutral voice, so that the source is credited without nickjj's personal testimonials leading the document.
3. As the repo owner, I want `.github/FUNDING.yml` deleted, so that the GitHub Sponsor button doesn't point at nickjj on my repo.
4. As the repo owner, I want the default branch renamed from `master` to `main`, so that the repo matches current convention.
5. As the repo owner, I want the `DOTFILES_UPSTREAM_URL` env var, the bootstrap `remote add upstream` logic, and the `./install --diff` flag all removed, so that the repo has no tooling coupling to nickjj and is consistent with a "re-origin, not fork" identity.
6. As the repo owner, I want the full commit history from nickjj/dotfiles retained up to the re-origin point, so that `git blame` still works and the LICENSE attribution matches real ancestry.
7. As a user installing on Linux or macOS, I want WSL support completely removed, so that the install script contains no dead code paths for a platform I don't use.
8. As a user installing on Linux or macOS, I do not want a refuse-gate that checks for WSL before failing — the detection itself is gone, and Linux paths run unconditionally on Linux.
9. As the repo owner, I want the `mnt/` directory and `etc/wsl.conf` deleted, so that no WSL-only template files persist in the tree.
10. As the repo owner, I want all nickjj-personal curl-bash scripts (bmsu, invoice, lcurl, notes, plutus, wait-until, webserver) stripped from `SCRIPTS_INSTALL` defaults, so that my fresh installs don't download someone else's tools.
11. As the repo owner, I want the yarn auto-install block removed from `install_programming_languages`, so that a global yarn isn't installed on every machine (pnpm/npm cover my needs via mise).
12. As the repo owner, I want nickjj's blog URL in the GPG commit-signing comment replaced with a neutral `man gpg-agent` reference, so that install script comments don't point at external personal content.
13. As the repo owner, I want the YouTube-description snippet removed from `.config/nvim/snippets/markdown.json` (and the file deleted if the remaining Hugo snippet isn't used), so that my nvim doesn't carry someone else's content template.
14. As the repo owner, I want `_docs/scripts.md` emptied (kept as a stub `# Scripts` file), so that the file path still exists for future content but the nickjj-personal tool inventory is gone.
15. As a user, I want the default font changed from Inconsolata Nerd Font (`latest`) to IBM Plex Mono Nerd Font v3.4.0 (version-pinned), so that fonts don't silently shift across installs.
16. As a user, I want my ghostty, tmux, and nvim configs swapped to the curated versions in `/Users/imrellx/code/personal/ivn-term/config/`, so that my terminal environment matches what I've already tuned.
17. As a user, I want the swapped configs surgically modified to honor nickjj's theme indirection (ghostty `config-file = ?theme`, tmux `source-file "~/.config/tmux/theme.conf"`, nvim plugin-declaration + `plugins/theme.lua` pattern), so that `dot-theme-set` still works across the whole stack — not just the GUI tools.
18. As a user, I want helix, starship, sesh, superfile, vim, yazi, lazygit, and mise configs imported from `ivn-term/config/`, so that the tools I use daily arrive pre-configured.
19. As a user, I want `STARSHIP_CONFIG` exported from zsh so that starship reads from `~/.config/starship/starship.toml` (the subdirectory form) instead of the default root-level path.
20. As a user on Arch, I want `helix`, `starship`, `sesh`, `yazi`, `superfile`, `vim`, `lazygit`, `1password-beta`, `1password-cli` added to the pacman/AUR package lists, so that a fresh Arch install gets them.
21. As a user on macOS, I want the same tools added to `PACKAGES_BREW` and `PACKAGES_BREW_CASK` (1password as a cask), so that a fresh macOS install gets them.
22. As a user on Debian/Ubuntu, I want the same tools added to `PACKAGES_APT` where apt has them, and to `MISE_DEBIAN` as a fallback where apt doesn't, so that Debian parity is maintained without inventing new tiers.
23. As a user on Debian/Ubuntu, I want the official 1Password signed apt repository set up automatically during install, so that 1Password gets real updates from Anthropic's recommended source.
24. As a user, I want the `MISE_LANGUAGES` default list updated to 7 entries — `node@22`, `bun@latest`, `python@latest`, `rust@latest`, `go@latest`, `zig@latest`, `pi` via `npm:@mariozechner/pi-coding-agent@latest` — so that all my language runtimes and the Pi coding agent install through one tier.
25. As a user, I want node pinned to `@22` (not `@latest`), so that npm tooling compatibility doesn't break on major node bumps.
26. As a user, I want Claude Code installed via Anthropic's official native installer (`curl https://claude.ai/install.sh | bash -s latest`) from a dedicated `install_claude_code()` function, so that I get the officially-recommended distribution path rather than the npm package (which can lag).
27. As a user, I want `install_claude_code()` to be idempotent — re-running it on a machine that already has Claude Code upgrades in place without erroring.
28. As a user, I want the default theme switched from tokyonight-moon to Flexoki Dark, so that a fresh install boots into my preferred palette without manual intervention.
29. As the repo owner, I want `_themes/flexoki-dark/` authored as a full theme entry (13 files: `_theme.json`, `btop.theme`, `fzf.sh`, `ghostty`, `gtk.ini`, `mako`, `niri.kdl`, `nvim.lua`, `swaylock`, `tmux.conf`, `walker.css`, `waybar.css`, `zathurarc`), so that `set_theme()` can switch to Flexoki the same way it switches to gruvbox or tokyonight.
30. As the repo owner, I want `_themes/gruvbox-dark-medium/` and `_themes/tokyonight-moon/` retained as alternate themes, so that I can try alternates via `dot-theme-set` without recreating them.
31. As the repo owner, I want no Flexoki GTK theme authored or downloaded in Phase 1 — Flexoki GTK doesn't exist upstream and authoring one is a separate effort; `set_theme()` already falls back gracefully when a theme's GTK files are missing.
32. As the repo owner, I want `install-config.example` updated to match the new defaults: WSL tier removed, comments lightly neutralised.
33. As the repo owner, I want `.github/workflows/ci.yml` triggered only on `main` (drop `master`), so that CI aligns with the new default branch.
34. As the repo owner, I want `docs/adr/0001-re-origin-without-upstream-tooling.md` preserved, so that the re-origin decision is documented for future readers who wonder why the git history starts under nickjj but no `upstream` remote exists.
35. As the repo owner, I want `CONTEXT.md` at the repo root preserved, so that the domain language established during planning is available to future contributors (including AI assistants) without re-deriving it.

## Implementation Decisions

### Modules

Phase 1 decomposes into 12 modules, most landing as separate commits:

1. **Identity**: LICENSE dual copyright, README rewrite, FUNDING.yml delete, branch rename, strip `DOTFILES_UPSTREAM_URL` env var + bootstrap upstream-remote logic + install `--diff` flag.
2. **WSL purge**: delete `mnt/` and `etc/wsl.conf`; strip all WSL branches from `install` and `OS_IN_WSL` detection from `bootstrap`; no defensive refuse-gate.
3. **Nickjj personal strips**: empty `DEFAULT_SCRIPTS_INSTALL`; delete yarn auto-install block; clean or delete `.config/nvim/snippets/markdown.json`; empty `_docs/scripts.md` to a stub; replace nickjj blog URL in GPG comment with neutral `man gpg-agent` reference.
4. **Font swap**: Inconsolata → IBM Plex Mono Nerd Font v3.4.0 (version-pinned, not `latest`); update download URL, temp paths, and cp glob in `install`; update `font-family` in ghostty config.
5. **Config swap** (nvim, ghostty, tmux): import from ivn-term; surgically rewrite to honor nickjj's theme indirection (strip hardcoded palette/colorscheme from each, add `?theme` include / `source-file` / plugin-declaration hooks); the three files deliberately diverge from ivn-term upstream.
6. **Config additions**: import helix, sesh, starship, superfile, vim, yazi, lazygit, mise configs from ivn-term; add `STARSHIP_CONFIG` export to zsh config.
7. **Package additions**: add new tools to per-distro package arrays (pacman/AUR on Arch, brew/cask on macOS, apt or mise-fallback on Debian); add signed apt repo setup for 1Password on Debian.
8. **Mise extension**: rewrite `DEFAULT_MISE_LANGUAGES` to 7 entries; `pi` uses the `npm:` backend with key `pi` so the existing install loop handles it unchanged.
9. **Claude Code install**: new `install_claude_code()` function invoking the official native installer; wired into main install flow adjacent to `install_external_scripts`; idempotent by construction (native installer handles already-installed upgrades).
10. **Flexoki theme**: author `_themes/flexoki-dark/` by copying `_themes/tokyonight-moon/` and translating palette values to the Flexoki palette (source of truth: ivn-term ghostty config's palette block); change `set_theme()` default from `tokyonight-moon` to `flexoki-dark`.
11. **Install-config example**: update to match new defaults, drop WSL tier entries.
12. **CI workflow**: `.github/workflows/ci.yml` triggers only on `main`.

### Architecture decisions

- **Re-origin, not fork**: the repo has no `upstream` git remote, no `DOTFILES_UPSTREAM_URL` env var, no `--diff` flag, no tooling coupling to nickjj. Source is credited in LICENSE and README only. Documented in ADR-0001.
- **Per-distro native packaging retained**: pacman+AUR on Arch, apt (+ mise fallback) on Debian, brew + cask on macOS. No migration to brew-on-Linux. Matches existing architecture.
- **Theme indirection retained and extended**: nickjj's `set_theme()` symlink-based model is the single theming mechanism. Swapped CLI configs (nvim, ghostty, tmux) are rewritten to honor it instead of hardcoding colors; `_themes/flexoki-dark/` slots in alongside existing themes.
- **Claude Code via native installer, not mise npm backend**: the native installer is Anthropic's recommended path; the `npm:@anthropic-ai/claude-code` backend occasionally lags releases. Pi uses mise npm backend because it's officially distributed that way and doesn't have a native installer.
- **Node pinned to `@22`**, everything else in MISE_LANGUAGES at `@latest`. Node majors have historically broken npm tooling; other runtimes tolerate `@latest`.
- **Flexoki light variant and Flexoki GTK theme deferred** to Phase 2. Phase 1 ships Flexoki Dark only.

### Rewiring patterns for swapped configs (module 5)

- **ghostty**: remove inline `background`, `foreground`, and `palette = N=#...` block; add `config-file = ?theme` directive; keep `font-family` and other non-color settings. Palette moves into `_themes/flexoki-dark/ghostty`.
- **tmux**: strip any `status-*`, `pane-*-style`, or `window-status-*-style` color directives; append `source-file -q "~/.config/tmux/theme.conf"` at the end.
- **nvim**: replace ivn-term's file-reading theme selector with a plain plugin-declaration file listing all three theme plugins (`kepano/flexoki-neovim`, `ellisonleao/gruvbox.nvim`, `folke/tokyonight.nvim`); the active colorscheme selection lives in `_themes/<active>/nvim.lua` which symlinks to `plugins/theme.lua`.

## Testing Decisions

### What "good test" means for this repo

Good tests exercise external, observable behaviour — not implementation details. For a dotfiles repo this means: "after running `./install`, does the machine have the tools and symlinks the user expects?" rather than "did function X call function Y with argument Z?" The repo is primarily bash and config files; there is no unit-testable business logic.

### Existing test harness

`./run ci:test` runs `shellcheck` on all shell-shebanged files, `shfmt` for formatting, and `ruff check`/`ruff format` for Python (no `.py` files currently; the ruff config exists defensively for future additions). GitHub Actions runs this on every push and PR. Every Phase 1 shell edit must leave `./run ci:test` passing.

### Modules that warrant explicit automated tests beyond shellcheck

Three modules have seams clean enough for smoke tests:

- **Module 5 (Config swap with theme rewiring)**: `tmux -f .config/tmux/tmux.conf kill-server` should parse without error after the swap and rewire; `nvim --headless -c "quit"` should exit zero with the swapped config; `ghostty +validate-config` (if supported by the ghostty version) should pass. These catch syntax breakage in the rewiring without needing a full VM.
- **Module 9 (Claude Code install)**: after running `install_claude_code()` in a clean environment, `claude --version` succeeds. Idempotency check: running it a second time also succeeds without error.
- **Module 10 (Flexoki theme)**: after `dot-theme-set flexoki-dark`, all 13 theme symlinks resolve (tested by `test -L ~/.config/ghostty/theme && test -L ~/.config/tmux/theme.conf && ...`). Same check against `tokyonight-moon` and `gruvbox-dark-medium` confirms theme-switching still works for the alternates. This is the main test of `set_theme()` after changes.

### Modules relying on shellcheck + manual VM validation only

Modules 1, 2, 3, 4, 6, 7, 8, 11, 12 are deletions or data changes where shellcheck catches syntactic regressions and a manual `./install` run on one VM per supported OS (Arch, Debian, Ubuntu, macOS) validates end-to-end. No automated tests authored for these — the cost/benefit doesn't clear the bar.

### Prior art

The existing `./run ci:test` pipeline is the model. New smoke tests, if added, should live as a new task in `./run` (e.g. `ci:smoke`) and be callable from GitHub Actions alongside the existing lint step.

## Out of Scope

- **Phase 2 work**: Hyprland as a secondary Arch GUI (alongside niri, not replacing it); imports from `/Users/imrellx/code/lab/omarchy/bin`; Flexoki Light variant; Flexoki GTK theme authoring; migration from `DEFAULT_MISE_LANGUAGES` associative array to a `mise` config-toml + tasks model; any `./install` architectural rework.
- **New operational scripts** in `.local/bin/`: current inventory is kept intact; additions from other repos are a separate future effort.
- **Shell replacement**: the nickjj zsh config stays for now. Swapping zsh for a curated version (or adopting fish / nushell) is a future decision.
- **btop and git config swaps**: nickjj's versions win in Phase 1; personal versions deferred.
- **Creating the `imrellx/dotfiles` GitHub repo**: this PRD is authored assuming the repo will be created by the user. The `origin` remote change and initial push happen once the repo exists on GitHub.
- **`opencode` and `shell` configs from ivn-term**: skipped in Phase 1.
- **Vim-as-a-fallback-to-nvim**: vim is added as a package and given an ivn-term config, but no fallback logic or "use vim if nvim fails" behavior is wired up.
- **`./install --diff` replacement**: removing the flag is in scope; replacing it with a new upstream-comparison workflow is not. Manual `git fetch` + `git diff` when the mood strikes.

## Further Notes

- **Origin remote migration**: the current `origin` points at `nickjj/dotfiles`. Post-re-origin, the owner needs to create `imrellx/dotfiles` on GitHub, update `origin`, push `main`, and (optionally) delete local `master`. This is a manual step outside the automated Phase 1 changes.
- **The ADR and the CONTEXT.md at repo root are deliberately kept**: `docs/adr/0001-re-origin-without-upstream-tooling.md` records why the `upstream` remote doesn't exist, and `CONTEXT.md` records the domain language. Future readers (including AI) land on these first.
- **Reference sources**: `ivn-term` (local clone at `/Users/imrellx/code/personal/ivn-term`) is the authoritative source for config swaps and additions. `omarchy` (local clone at `/Users/imrellx/code/lab/omarchy`) is the reference pattern for 1Password handling on Arch (AUR packages + Hyprland window rules + `omarchy-lock-screen` integration); only the Arch AUR part lands in Phase 1.
- **Commit ordering**: identity first (module 1) so subsequent commits land under the new identity; CI workflow last (module 12) so we don't pre-break the pipeline before everything else is in place.
- **Risk**: the theme-rewiring in module 5 is the single most fragile change — it edits three ivn-term configs in ways that diverge from their upstream. A one-line banner comment in each file should call this out (`-- theme indirection managed by set_theme; don't re-bake palette inline`).
- **Idempotency**: the entire install flow (`./install`) is expected to be idempotent — running it a second time on the same machine should be a no-op or an in-place upgrade. Every new install step added in Phase 1 (Claude Code, 1Password signed apt repo, Flexoki theme symlinks) must maintain this property.
