# shellcheck shell=bash

# Disable CTRL-s from freezing the terminal's output.
stty stop undef

# Enable comments at the interactive prompt.
setopt interactive_comments

# Sibling modules. Order matters: .zoptions runs compinit before .inits
# sources the zsh plugins that hook into the completion system.
# shellcheck disable=SC1091
[ -f "${ZDOTDIR}/.aliases" ] && . "${ZDOTDIR}/.aliases"
# shellcheck disable=SC1091
[ -f "${ZDOTDIR}/.functions" ] && . "${ZDOTDIR}/.functions"
# shellcheck disable=SC1091
[ -f "${ZDOTDIR}/.zoptions" ] && . "${ZDOTDIR}/.zoptions"
# shellcheck disable=SC1091
[ -f "${ZDOTDIR}/.inits" ] && . "${ZDOTDIR}/.inits"

# Per-machine overrides (install-seeded, user-editable).
# shellcheck disable=SC1091
[ -f "${ZDOTDIR}/.zshrc.local" ] && . "${ZDOTDIR}/.zshrc.local"
# shellcheck disable=SC1091
[ -f "${ZDOTDIR}/.aliases.local" ] && . "${ZDOTDIR}/.aliases.local"
