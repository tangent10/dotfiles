#!/bin/bash

function dotstatus() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" status
}
function dotadd() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" add "$@"
}
function dotcommit() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" commit "$@"
}
function dotpush() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" push "$@"
}
function dotpull() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" pull "$@"
}
function dotdiff() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" diff "$@"
}
function dotlog() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" log "$@"
}
function dotremote() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" remote "$@"
}

git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
