#!/bin/bash

function get_module()
{
  [ -z "$1" ] && printf 'usage:\n  get_module $language $name\n' && return 0

  local language="$1"
  local name="$2"

  local langdir="$GHOST_PKG_REPOSITORY/$language"
  [ ! -d "$langdir" ] && echo "lang package does not exist at path $langdir" && return 0
  local modpath="$langdir/$name"
  [ ! -f "$modpath" ] && echo "module file does not exist at path $modpath" && return 0

  cat "$modpath"
}

function ls_modules()
{
  find $GHOST_PKG_REPOSITORY -path '*.git*' -prune -o -type f | ack -v \.git
}
