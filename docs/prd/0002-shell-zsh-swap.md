# Shell/zsh swap: reshuffle .config/zsh/ to ivn-term modules

## Problem Statement

My dotfiles' zsh config has three working problems and one structural one.

Working problems:

1. **Starship never activates.** The config file at `~/.config/starship/starship.toml` loads, `STARSHIP_CONFIG` is exported, but nothing calls `starship init`. The 126-line `.zshrc` hand-rolls a PROMPT using a `git_prompt()` function and zsh color codes. Starship is dead weight today.
2. **Four zsh plugins, one I don't use.** `zsh-vi-mode`, `fast-syntax-highlighting`, `zsh-autosuggestions` I use daily. `fzf-tab` I don't. All four live in `$XDG_DATA_HOME` and get cloned by `dot-update-zsh-plugins` on every install.
3. **Install-appended OS aliases shadow eza.** `configure_shell()` appends `alias ls="ls -G"` (darwin) or `alias ls="ls --color=auto"` (linux) to `.aliases.local`, plus grep/fgrep/egrep friends. `.local` loads after `.aliases`, so any future eza alias in the base `.aliases` gets silently overridden.

Structural problem:

My other config swaps (ghostty landed; nvim + tmux pending) follow a pattern: delete the upstream nickjj directory, lift `ivn-term`'s equivalent in. A clean directory swap for zsh would move everything to `.config/shell/` (ivn-term's layout). But `configure_shell()` cohabits with `.config/zsh/` paths: it writes `DOTFILES_PATH` into `.zprofile.local`, OS-specific aliases into `.aliases.local`, Linux GUI `uwsm start` into `.zprofile.local`. `configure_xdg_directories()` writes `.xdg.local`. A directory swap would require rebuilding all those hooks against `.config/shell/`. CONTEXT.md has `zsh` listed under "deferred swaps" because of this.

I want starship activated, plugin count trimmed, shell posture aligned with ivn-term's modular split, and the install-script cohabitation preserved so this PR stays focused.

## Solution

Reshuffle inside `.config/zsh/` instead of moving to `.config/shell/`. Keep the nickjj scaffold (`.zshrc`, `.zprofile`, `.zshenv`, `.aliases` + `.local` override tier). Lift ivn-term's `config/shell/` content (`envs`, `aliases`, `functions`, `zoptions`, `inits`) into dotted siblings inside `.config/zsh/`. Rewrite `.zshrc` as a thin loader that sources siblings + `.local` overrides. Drop `fzf-tab`; keep the other three plugins. Keep vi mode. Move brew shellenv detection and `HOMEBREW_NO_ANALYTICS` into `.envs`. Delete the install-script hunks that become redundant (OS-specific alias appender; macOS brew block). Add `zoxide` (sesh dependency for frecent-dirs) and `gum` (for `gwr` worktree-remove prompt) to all three package manifests.

ADR 0002 captures the Shape A vs Shape B+ trade-off. CONTEXT.md gets a reshuffle-in-place note and a zoxide-sesh coupling entry.

## User Stories

1. As the repo owner, I want starship to activate on shell launch, so that my configured prompt actually renders.
2. As the repo owner, I want `.zshrc` to be a thin loader sourcing `.envs`, `.aliases`, `.functions`, `.zoptions`, `.inits`, plus `.local` overrides, so that each concern lives in one file and the load path is inspectable.
3. As the repo owner, I want `.envs` consolidating all env vars (EDITOR, VISUAL, PATH prepends, brew shellenv, HOMEBREW_NO_ANALYTICS, ZVM cursor envs, ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE, fzf/config.sh source), so that env bootstrap is one read.
4. As the repo owner, I want `.functions` carrying ivn-term's utility functions (`mkcd`, `extract`, `port`, `transcode-*`, `img2*`, `fip`/`dip`/`lip`, `tdl`/`tdlm`/`tsl`, `iso2sd`, `format-drive`, `ga`, `gwr`) minus `git-id`, so that I get useful helpers without cruft I won't invoke.
5. As the repo owner, I want `.zoptions` carrying zsh options, completion config, `compinit`, history settings, and `bindkey -v`, so that zsh-specific configuration lives in one file.
6. As the repo owner, I want `.inits` carrying tool inits (starship, zoxide, fzf, mise) and plugin sources in the correct order, so that all initialization is sequenced predictably.
7. As the repo owner, I want `.zshenv` untouched (`ZDOTDIR` + `STARSHIP_CONFIG`), so that zsh's earliest-load chain keeps working as-is.
8. As the repo owner, I want `.zprofile` shrunk to three source lines plus login-only concerns (`GPG_TTY`, `LESS`, `LESS_TERMCAP`, GPG/pass/delta envs), so that the login path is lean.
9. As the repo owner, I want `bindkey -v` (vi mode) kept, so that my muscle memory is preserved.
10. As the repo owner, I want `zsh-vi-mode`, `zsh-autosuggestions`, and `fast-syntax-highlighting` retained, so that I keep cursor-shape feedback, ghost completions, and inline typo highlighting.
11. As the repo owner, I want `fzf-tab` dropped, so that there's one fewer plugin to clone and configure.
12. As the repo owner, I want plugins sourced in the order `zsh-vi-mode` → `zvm_after_init_commands` for fzf + history bindings → `zsh-autosuggestions` → `fast-syntax-highlighting` last, so that bindings survive vi-mode init and syntax highlighting wraps zle last.
13. As the repo owner, I want `compinit` to run in `.zoptions` (before plugin sources in `.inits`), so that completions are ready when plugins look for them.
14. As the repo owner, I want `HISTFILE` at `$XDG_STATE_HOME/zsh_history`, so that history lives outside the repo and doesn't dirty `git status`.
15. As the repo owner, I want `GPG_TTY` captured in `.zprofile` at login, so that gpg-agent can prompt for passphrases during commit signing.
16. As the repo owner, I want fzf sourced twice (defaults from `fzf/config.sh` in `.envs`; keybindings via `fzf --zsh` in `.inits` inside `zvm_after_init_commands`), so that preview options are set and Ctrl-R / Ctrl-T / Alt-C bindings survive vi-mode init.
17. As the repo owner, I want `DOTFILES_PATH` still written to `.zprofile.local` by `configure_shell()`, so that the install-configurable path continues to be install-owned.
18. As the repo owner, I want no tmux auto-launch, so that new shells don't force me into tmux. I'll invoke `t` on demand.
19. As the repo owner, I don't want bash parity in this PR (no `.bashrc`, no `.inputrc` lift), so that scope stays focused. A later follow-up PR can add it if needed.
20. As the repo owner, I want `ls`/`ll`/`la`/`lt` aliases backed by eza, so that I see icons + git status + grouping by default.
21. As the repo owner, I want `grep='grep --color=auto'` as the universal base (no OS branching), so that the install script doesn't need to append OS-specific color variants.
22. As the repo owner, I want ivn-term's cd/docker/editor/tmux short aliases (`..`, `...`, `....`, `dk`, `dkc`, `v`, `vi`, `n()`, `t`, `ta`, `tl`, `tn`), so that common navigations take fewer keystrokes.
23. As the repo owner, I want `cx` (clear screen + `claude --allow-dangerously-skip-permissions`) adopted but not `c='opencode'` (opencode not packaged), so that adopted aliases line up with installed binaries.
24. As the repo owner, I want `cat='bat --style=plain'` command-v guarded, so that `cat` falls back gracefully when bat is absent.
25. As the repo owner, I want ivn-term's short git cluster (`g`, `gs`, `gc`, `gcm`, `gcam`, `gp`, `gl`, `gco`) dropped, so that my alias set matches my workflow (agent-driven git, not CLI-driven).
26. As the repo owner, I want my existing aliases (`sz`, `SZ`, `dt`, `lz`, `lp`, `diff`, `pf`, `gi`, `gcl`, `ge`, `drun`, `k`, `tf`, `ymp3`, `run`, `755d`, `644f`, `vss`, `vdt`) kept, so that muscle memory survives.
27. As the repo owner, I want my existing fat `eza` alias kept, so that explicit `eza` invocations still produce the detailed long-form output.
28. As the repo owner, I want `ga` (worktree create + `mise trust` + cd) and `gwr` (worktree remove, renamed from ivn-term's `gd`) as the git-related functions, so that agent handoff via worktrees is a one-liner.
29. As the repo owner, I want `.local/bin/gd`, `.local/bin/gl`, `.local/bin/gbd` untouched, so that my fzf-powered review tooling isn't shadowed by adopted aliases or functions.
30. As the repo owner, I want `git-id` dropped, so that rare identity swaps stay hand-driven.
31. As the repo owner, I want `gum` installed (arch pacman, darwin brew, debian aqua-via-mise), so that `gwr` and future interactive helpers can prompt.
32. As the repo owner, I want `zoxide` installed (arch pacman, darwin brew, debian mise), so that sesh's frecent-dirs session picker has its default source.
33. As the repo owner, I want `dot-update-zsh-plugins` trimmed to three plugins (drop fzf-tab line), so that `install_zsh_plugins()` doesn't clone a plugin I don't use.
34. As the repo owner, I want `configure_shell()` lines 1704-1722 (OS-specific alias appends to `.aliases.local`) deleted, so that install doesn't shadow eza or fight the base `.aliases`.
35. As the repo owner, I want `configure_shell()` lines 1689-1702 (macOS brew + HOMEBREW_NO_ANALYTICS block) deleted, so that brew detection lives in `.envs` and there's no install-time branching.
36. As the repo owner, I want `.envs`'s brew shellenv detection to cover only `/opt/homebrew` and `/usr/local/Homebrew` (no linuxbrew branch), so that the config matches CONTEXT.md's "brew-on-Linux not adopted" decision.
37. As the repo owner, I want `HOMEBREW_NO_ANALYTICS=1` always exported in `.envs` (no OS branching), so that the env var is set unconditionally and harmless on Linux.
38. As the repo owner, I want four new symlinks added to `_install/default/config_install` (`.envs`, `.functions`, `.zoptions`, `.inits`), so that the new siblings get linked into `~/.config/zsh/` on install.
39. As the repo owner, I want the `.zshrc.local`, `.zprofile.local`, `.aliases.local`, `.xdg.local` symlinks untouched, so that the `.local` override tier continues to work.
40. As a future reader, I want ADR 0002 explaining why `.config/zsh/` is hybrid-style, so that I don't try to normalize it to one extreme and break install hooks.
41. As a future reader, I want CONTEXT.md updated with the reshuffle-in-place note and the zoxide-sesh coupling, so that terminology and rationale are discoverable without reading the PR.
42. As the repo owner, I want this PR scoped to a fresh-install target (no in-place upgrade migration), so that execution stays simple.
43. As the repo owner, I want tool init calls (starship, zoxide, mise) gated behind `command -v` in `.inits`, so that missing tools produce no-ops instead of errors.
44. As the repo owner, I want arrow-key + Ctrl-p/Ctrl-n history-search bindings preserved inside `zvm_after_init_commands`, so that recall keystrokes still work after zsh-vi-mode wipes bindings on init.
45. As the repo owner, I want `autoload -U colors; colors` kept in `.zshrc` only if something still needs `$fg`/`$bg` (not the prompt, since starship owns that now), so that we don't autoload unused machinery.
46. As the repo owner, I want `stty stop undef` and `setopt interactive_comments` kept in `.zshrc`, so that Ctrl-S doesn't freeze the terminal and `#` comments work at the interactive prompt.
47. As the repo owner, I want `INC_APPEND_HISTORY` (immediate write) preserved from current behavior rather than ivn-term's `append_history` (on-exit write), so that history survives shell crashes or forced terminations.
48. As the repo owner, I want `EXTENDED_HISTORY` set so zsh writes native timestamps into the history file, replacing the bash-oriented `HISTTIMEFORMAT` export from the old `.zshrc`.
49. As the repo owner, I want the old `.zshrc`'s hand-rolled `git_prompt()` function, `PROMPT` export, `setopt PROMPT_SUBST`, `autoload -U colors; colors`, and the two `fzf-tab` `zstyle` configs all explicitly removed, so that nothing from the pre-starship prompt stack or the dropped plugin lingers.
50. As the repo owner, I want `setopt correct` and `setopt auto_cd` adopted from ivn-term's zoptions, so that typos get suggestions and a bare directory path cds into it.

## Implementation Decisions

**Final `.config/zsh/` contents:**

- `.zshenv` — unchanged; `ZDOTDIR` and `STARSHIP_CONFIG` exports.
- `.zshrc` — thin loader (~20 lines). Keeps: `stty stop undef`, `setopt interactive_comments`. Explicit removals from the current 126-line version: hand-rolled `git_prompt()` function, `PROMPT` export, `setopt PROMPT_SUBST`, `autoload -U colors; colors` (prompt owned by starship now), `fzf-tab` source + its two `zstyle` configs, inline `zvm_after_init_commands+=(...)` (moves to `.inits`), inline `export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE` (moves to `.envs`), inline `. "${XDG_CONFIG_HOME}/fzf/config.sh"` (moves to `.envs`). Sources in this order: `.aliases`, `.functions`, `.zoptions`, `.inits`, `.zshrc.local`, `.aliases.local`.
- `.zprofile` — sources `.xdg.local`, `.envs`, `.zprofile.local`. Also sets `GPG_TTY`, `LESS`, `LESS_TERMCAP`, GPG/pass/delta envs.
- `.envs` — new. `EDITOR=nvim`, `VISUAL=nvim`. PATH prepends via `_prepend_path` helper, called in this order (last call lands earliest in `$PATH`): `$HOME/.local/bin/local`, `$HOME/.local/bin`, `$XDG_DATA_HOME/mise/shims`. Resulting search order: mise-shims, `.local/bin`, `.local/bin/local`, then system `$PATH`. Brew shellenv detection (macOS-only; `/opt/homebrew` for arm64, `/usr/local/Homebrew` for x86_64; no linuxbrew branch). `HOMEBREW_NO_ANALYTICS=1` always exported. `ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20`. `ZVM_NORMAL_MODE_CURSOR="${ZVM_CURSOR_BLOCK:-}"`. `ZVM_INSERT_MODE_CURSOR="${ZVM_CURSOR_BEAM:-}"`. Sources `${XDG_CONFIG_HOME}/fzf/config.sh` for `FZF_DEFAULT_OPTS` + theme hook.
- `.aliases` — replaces existing with merged content (see Aliases below).
- `.functions` — new. Ivn-term utility functions minus `git-id`; `gd` renamed to `gwr`.
- `.zoptions` — new. `autoload -U compinit; compinit; _comp_options+=(globdots)` at top. `bindkey -v`. `HISTFILE` at `$XDG_STATE_HOME/zsh_history`; `HISTSIZE=10000`; `SAVEHIST=10000`. History setopts: `INC_APPEND_HISTORY` (preserving current immediate-write behavior, not ivn-term's `append_history`), `HIST_IGNORE_ALL_DUPS`, `HIST_IGNORE_SPACE`, `HIST_REDUCE_BLANKS`, `HIST_VERIFY`, `share_history`, `EXTENDED_HISTORY`. Other setopts from ivn-term adopted verbatim: `extended_glob`, `correct`, `auto_cd`, `CHASE_LINKS`, `no_beep`, `COMBINING_CHARS`, `MENU_COMPLETE`, `AUTO_MENU`, `COMPLETE_IN_WORD`, `ALWAYS_TO_END`, `INTERACTIVE_COMMENTS`. Completion zstyles lifted verbatim from ivn-term.
- `.inits` — new. Shell detect. Command-v guarded tool inits for starship, zoxide, mise. Zsh-only plugin block in specified order.
- `.xdg.local`, `.zshrc.local`, `.zprofile.local`, `.aliases.local` — unchanged; install-managed or user-edit.

**Load sequence:**

`.zshenv` → `.zprofile` (sources `.xdg.local`, `.envs`, `.zprofile.local`) → `.zshrc` (sources `.aliases`, `.functions`, `.zoptions`, `.inits`, `.zshrc.local`, `.aliases.local`).

**Aliases, final merged set:**

- From ivn-term: `ls`, `ll`, `la`, `lt` (all eza), `ff`, `eff`, `..`, `...`, `....`, `dk`, `dkc`, `v`, `vi`, `n()`, `cx`, `t`, `ta`, `tl`, `tn`, `cat` (bat, command-v guarded), `grep --color=auto`.
- Kept from dotfiles: `sz`, `SZ`, `dt`, `lz`, `lp`, `eza` (fat variant), `diff`, `pf`, `gi`, `gcl`, `ge`, `drun`, `k`, `tf`, `ymp3`, `run`, `755d`, `644f`, `vss`, `vdt`.
- Dropped from ivn-term: `c`, `lzd`, `g`, `gs`, `gc`, `gcm`, `gcam`, `gp`, `gl`, `gco`.
- Dropped from dotfiles: `l`.

**Functions, final adopted set:**

- `mkcd`, `extract`, `port`, `iso2sd`, `format-drive`, `transcode-video-1080p`, `transcode-video-4K`, `img2jpg`, `img2jpg-small`, `img2jpg-medium`, `img2png`, `fip`, `dip`, `lip`, `tdl`, `tdlm`, `tsl`, `ga`, `gwr` (renamed from ivn-term's `gd`).
- Dropped: `git-id`.

**Plugin load order inside `.inits`** (compinit already ran in `.zoptions`):

1. `zsh-vi-mode.plugin.zsh`
2. `zvm_after_init_commands+=(". <(fzf --zsh)", Ctrl-p/Ctrl-n history-search bindings, arrow-key history-search bindings)`
3. `zsh-autosuggestions.zsh`
4. `fast-syntax-highlighting.plugin.zsh` (last)

**Install-script changes:**

- `_install/default/config_install`: add four new symlinks (`.envs`, `.functions`, `.zoptions`, `.inits`) alongside existing zsh entries.
- `.local/bin/dot-update-zsh-plugins`: remove `clone_or_pull "Aloxaf/fzf-tab"`.
- `install:configure_shell()` lines 1704-1722: delete darwin/linux alias appender.
- `install:configure_shell()` lines 1689-1702: delete macOS HOMEBREW_NO_ANALYTICS + brew shellenv block. Detection moves into `.envs`.
- `_install/default/packages/arch`: add `"gum"`, `"zoxide"` to `DEFAULT_PACKAGES_PACMAN`.
- `_install/default/packages/darwin`: add `"gum"`, `"zoxide"` to `DEFAULT_PACKAGES_BREW`.
- `_install/default/packages/debian`: add `"aqua:charmbracelet/gum"`, `"zoxide"` to `DEFAULT_MISE_DEBIAN`.

**CONTEXT.md updates** (already landed during discussion):

- `Config swap` entry: zsh moved from "deferred" to "landed post-Phase 1" with pointer to reshuffle-in-place note.
- New entry under Configs: `Zsh swap pattern (reshuffle-in-place)`.
- New entry under Configs: `Zoxide-sesh coupling`.

**ADR** (already landed): `docs/adr/0002-zsh-swap-reshuffle-in-place.md` captures Shape A vs Shape B+.

**No deep-module surface.** This is a config reshuffle. Shell files are data, not behavior. The `.envs` / `.functions` / `.zoptions` / `.inits` split is semantic grouping, not encapsulated interface.

## Testing Decisions

Shell config has no automated test harness in this repo. Verification is manual, post-install, across macOS and at least one Linux target.

**What makes a good test here:** external behavior at a fresh shell, not file contents or specific line presence.

**Shell-level verification checklist, post-install:**

1. New shell renders starship prompt (directory, git branch + status, language version, duration, success/error character).
2. `type ls` shows the eza alias. `ls` invocation renders icons + git info.
3. `bindkey | head -5` confirms vi mode.
4. Typing a partial-match command shows gray ghost completion (zsh-autosuggestions).
5. Known binary turns green, typo turns red (fast-syntax-highlighting).
6. `Ctrl-R` opens fzf history picker; `Ctrl-T` opens fzf file picker with bat preview; `Alt-C` opens fzf dir picker.
7. Arrow Up / Ctrl-P / Ctrl-N perform prefix-based history search.
8. `t` attaches to or creates tmux session `Work`.
9. Inside tmux, `sesh` lists sessions including frecent dirs sourced from zoxide.
10. `ga feature-x` creates worktree, cds in, `mise trust`s the path.
11. `gwr` inside a worktree prompts via `gum confirm` and removes worktree + branch on confirm.
12. `z <partial>` jumps via zoxide.
13. History writes to `$XDG_STATE_HOME/zsh_history`; `git status` inside the repo stays clean on new commands.
14. GPG commit signing works (agent prompts in-terminal).
15. `cx` clears and launches claude.
16. `env | grep HOMEBREW_NO_ANALYTICS` shows `=1` on macOS and Linux.

**Install-script verification:**

- Fresh install on macOS (VM or clean machine): `./install` completes. Zsh becomes default shell. `~/.config/zsh/` symlinks resolve (including the four new ones). `gum` and `zoxide` install via brew.
- Fresh install on Arch (VM): same checks. Pacman pulls `gum` and `zoxide`.
- Fresh install on Debian (container or VM): same checks. Mise resolves `aqua:charmbracelet/gum` and `zoxide`.

**Prior art:** none in this repo for shell config. Existing verification posture is `./install` + spot-check. This PR inherits that.

## Out of Scope

- **Bash parity.** No `.bashrc`. No `.inputrc` lift. Files are bash-compatible by design (except `.zoptions`), so a future bash parity PR is short. Motivated only by SSH-into-boxes-without-zsh, which isn't a current pain point.
- **Tmux auto-launch.** Considered and dropped. `t` alias covers on-demand. If a future preference reverses, use ghostty's `command =` option rather than shell-level launch.
- **opencode and lazydocker installs.** Their aliases (`c`, `lzd`) are dropped with them. Separate PRs if the tools become part of the workflow.
- **Nvim and tmux config swaps.** Each ships as its own follow-up PR. Each should follow the simpler directory-swap pattern since they don't cohabit with install-script-written files.
- **Theme indirection adjustments.** Shell files don't participate in the theme indirection layer.
- **In-place upgrade migration.** Target is a fresh bootstrap. No scripted migration of existing `.aliases.local` OS-specific appends or existing `.zsh_history`.
- **New install-script test harness.** No Docker-based test infrastructure added.

## Further Notes

- Reshuffle-in-place rationale is in ADR 0002. CONTEXT.md carries the short-form explanation.
- `.config/zsh/` post-swap intentionally mixes two conventions: nickjj's dotted entry points + `.local` override tier, plus ivn-term-derived dotted sibling modules. ADR 0002 exists so a future reader doesn't try to normalize the shape and quietly break install hooks.
- `zoxide` is installed as a sesh dependency (frecent-dirs session picker default source), not as a user-facing interactive tool. No zoxide alias.
- `gum` is installed for the `gwr` function and any future helper scripts that want interactive prompts.
- Plugin count: 4 → 3. Stale `$XDG_DATA_HOME/fzf-tab/` on existing machines is harmless; manual `rm -rf` if desired.
- History setopts deliberately deviate from ivn-term: we keep `INC_APPEND_HISTORY` (immediate write) over ivn-term's `append_history` (on-exit write) so history survives shell crashes. `EXTENDED_HISTORY` supplies zsh-native timestamps in the history file, which replaces the bash-oriented `HISTTIMEFORMAT` export from the old `.zshrc`.
