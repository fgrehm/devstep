#!/bin/bash

# some ls aliases
alias ls='ls --color=auto'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

export PATH="${PATH}:/.devstep/bin"

# TODO: Review these paths
profile_dirs="/etc /.devstep ${PWD}/.devstep"
for dir in $profile_dirs; do
  if [ -d "${dir}/.profile.d" ]; then
    for i in "${dir}/.profile.d/"*.sh; do
      if [ -r $i ]; then
        . $i
      fi
    done
    unset i
  fi
  if [ -d "${dir}/profile.d" ]; then
    for i in "${dir}/profile.d/"*.sh; do
      if [ -r $i ]; then
        . $i
      fi
    done
    unset i
  fi
done
