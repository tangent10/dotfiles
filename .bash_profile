#!/bin/bash

# source startup scripts
[ -r ~/.bashrc ] && source ~/.bashrc

for file in "$HOME/profiles/"*.profile; do
    if [[ $(basename "$file") != 'xf.profile' ]]; then
        source "$file"
    fi
done

# [2022-10-13 Thu 13:15:01] dropping quotes around the cd arg let's you expand the path with "*"
function repos()
{
  target_dir=$1
  cd $HOME/source/repos/$target_dir
}
function crypto()
{
  target_dir=$1
  cd $HOME/source/crypto/$target_dir
}
function projs()
{
  target_dir=$1
  cd $HOME/source/crypto/projs/$target_dir
}

# re-source this file
alias refresh='source ~/.bash_profile'

export PATH="/home/ghostlapdev/.local/share/solana/install/active_release/bin:$PATH"
export PATH="/home/ghostlapdev/.avm/bin:$PATH"

function museum() {
  local target_dir="$1"
  if [[ -z $2 ]] && [[ "$1" != '-h' ]] && [[ "$1" != --help ]]
  then
    cd "/mnt/c/Users/Nicholas/Dropbox/museum/$target_dir"
  else
    if [[ "$1" != '-q' ]] && [[ "$1" != '--query' ]]
    then
      printf 'usage:\n  musuem $path\n  musuem -q(uery) $filter\n'
      return 0
    else
      find "/mnt/c/Users/Nicholas/Dropbox/museum" | ack -i "$2"
    fi
  fi
}


function lines {
    if [[ $# -eq 2 ]]; then
        sed -n "${1},\$p" "$2"
    elif [[ $# -eq 3 ]]; then
        sed -n "${1},${2}p" "$3"
    else
        echo "Usage: lines <start-line> [<end-line>] <file>"
    fi
}

function gethere() {
  # i can't find where `here` is lol
  export here=$(pwd)
}

# opam configuration (ocaml thing)
test -r /home/ghostlapdev/.opam/opam-init/init.sh && . /home/ghostlapdev/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

alias githome='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
