# Zsh config swap as reshuffle-in-place, not directory swap

## Status

Accepted — 2026-04-22

## Context

Phase 1 established the "config swap" pattern: replace a config directory shipped with the nickjj base with one lifted from `ivn-term/config/`. Ghostty followed that pattern cleanly. When the deferred zsh swap came up, the same pattern would have meant deleting `.config/zsh/` and replacing it with ivn-term's flat `config/shell/` layout (`envs`, `aliases`, `functions`, `zoptions`, `inits`, `inputrc` + a thin `~/.zshrc` loader).

Three constraints surfaced that made a clean directory swap expensive:

1. **Install-script writes.** `configure_shell()` appends `DOTFILES_PATH`, macOS homebrew evals, and the Linux `uwsm start -- niri.desktop` directive into `.config/zsh/.zprofile.local`. `configure_xdg_directories()` writes XDG paths into `.config/zsh/.xdg.local`. Moving to `.config/shell/` meant rebuilding those hooks against new paths.
2. **User override tier.** `.zshrc.local`, `.zprofile.local`, `.aliases.local` are install-seeded, user-editable files. Real feature: per-machine tweaks that don't dirty tracked files. ivn-term has no equivalent.
3. **Zsh-only posture.** `configure_shell()` `chsh`s the user to zsh. Bash parity, the motivating scenario for ivn-term's flat layout, is not a current requirement.

Considered options:

- **A. Full directory swap.** Delete `.config/zsh/`, adopt `.config/shell/` verbatim. Matches the ghostty pattern. Rebuilds install hooks and the `.local` tier from scratch.
- **B+. Reshuffle-in-place.** Keep the nickjj scaffold (`.zshrc`, `.zprofile`, `.zshenv`, `.aliases` + `.local` tier). Lift ivn-term content into dotted siblings (`.envs`, `.functions`, `.zoptions`, `.inits`) inside `.config/zsh/`. Rewrite `.zshrc` as a thin loader sourcing the siblings. Install hooks untouched.

## Decision

**B+.** The zsh swap reshuffles inside `.config/zsh/` instead of moving to `.config/shell/`.

## Why

The install-script hooks are the expensive part. Shape A would have required rewriting five `configure_*` regions and the full `config_install` symlink block. Shape B+ adds four new symlinks and deletes two small `configure_shell()` hunks. The `.local` override tier is preserved at zero cost. Zsh-only is honest: we already `chsh` to zsh, so bash-parity's motivating scenario is out of scope. Future tmux and nvim swaps have no such cohabitation problem and should follow the simpler directory-swap pattern.

## Consequences

- `.config/zsh/` ends up with a mixed-style file set: nickjj-convention entry points plus locals alongside ivn-term-derived siblings. A future reader looking at the directory without this ADR will wonder why it's hybrid.
- Re-importing updates from `ivn-term/config/shell/` is a translation (file-by-file copy with renames), not a 1:1 diff.
- Bash parity, if ever wanted, becomes a follow-up PR: add `.bashrc` that sources `.envs` / `.aliases` / `.functions` / `.inits` directly, plus an `.inputrc` lift.
