#!/bin/bash
#

export PATH="$PATH:$HOME/.cabal/bin"

function hsg()
{
  stack ghci --no-load
}
