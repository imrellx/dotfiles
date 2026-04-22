# shellcheck shell=bash

# This file runs once at login.

# shellcheck disable=SC1091
. "${XDG_CONFIG_HOME:-"${HOME}/.config"}/zsh/.xdg.local"

# shellcheck disable=SC1091
. "${XDG_CONFIG_HOME:-"${HOME}/.config"}/zsh/.envs"

# Allows gpg-agent to prompt for passphrase (useful for signing commits).
GPG_TTY="$(tty)"
export GPG_TTY

# Add colors to less and man.
export LESS=-R
LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESS_TERMCAP_ue
export LESS_TERMCAP_mb=$'\e[1;31mm'   # begin blinking
export LESS_TERMCAP_md=$'\e[1;36m'    # begin bold
export LESS_TERMCAP_us=$'\e[1;332m'   # begin underline
export LESS_TERMCAP_so=$'\e[1;44;33m' # begin standout-mode - info box
export LESS_TERMCAP_me=$'\e[0m'       # end mode
export LESS_TERMCAP_ue=$'\e[0m'       # end underline
export LESS_TERMCAP_se=$'\e[0m'       # end standout-mode

# GPG / pass / delta
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"
export PASSWORD_STORE_DIR="${XDG_CONFIG_HOME}/password-store"
export DELTA_FEATURES="diff-so-fancy"

# Local overrides.
# shellcheck disable=SC1091
[ -f "${XDG_CONFIG_HOME}/zsh/.zprofile.local" ] && . "${XDG_CONFIG_HOME}/zsh/.zprofile.local"
