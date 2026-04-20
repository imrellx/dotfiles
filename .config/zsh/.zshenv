# shellcheck shell=bash

export ZDOTDIR="${XDG_CONFIG_HOME:-"${HOME}/.config"}/zsh"

# Starship config lives in a subdir so related state stays under one path.
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-"${HOME}/.config"}/starship/starship.toml"
