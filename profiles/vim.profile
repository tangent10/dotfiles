#!/bin/bash


# note, we alias 'vim' in ~/.bash_profile if we're on neovim
# so for here just refer to it as vim, and boombo banga you get
# clean-ish-enough abstraction


function vimplug()
{
  echo 'VIM! ``-^_^-#'

  if [ "$#" -lt 1 ]; then
    echo 'usage:'
    echo '    vimplug $remote-url $name?'
    return 0
  fi

  remote_url="${1}"

  plugin_dir_path="$(cat $HOME/bash_home)/.vim/pack/plugins/start"
  [ ! -d $plugin_dir_path ] && echo "plugin dir doesn't exist at: $plugin_dir_path" && return 1

  cd "$plugin_dir_path"
  repo_name="${2}"

  ([ -z "${repo_name}" ] && echo "installing ${repo_name} at $plugin_dir_path") || echo "installing $repo_name as ${repo_name} at $plugin_dir_path"

  ([ -z "${repo_name}" ] && git clone "${remote_url}") || git clone "${remote_url}" "${repo_name}"

  echo 'vimplug: done!'
  cd -
  return 0
}

function vtmp()
{
  # [2022-04-23 Sat 15:11:10], quick rough impl to shortcut the "open temp buffer pop it to 'scratchy' so you don't have to worry about usual persistence concerns" (ah you're quitting/writing/blahblah an nothing something)
  # NOTE: basically specialized to run exactly the right cmds to deal w/xf notions output
  # um, prob want to fix that "we print with a leading space" bullshit lol, um, ya just fix that now actually
  vim -c "call OpenToScratch()" -c "set ft=xf" -c "bd! 1" "$@"
}

function vimlite()
{
  vim -u $HOME/profiles/vim/lite.vim "$1"
}
