#!/bin/bash

export GIT_EDITOR=nvim

# [2021-11-09 Tue 16:12:05] for the record
# rediscovering this here and i think it's terrible directory semantics (maybe something else used to exist here who knows)
function gitignore()
{
  trp_base_gitextensions_dir="$HOME/.trp/git-extensions/ignores"
  if [ "$#" -lt 1 ]; then
    echo 'usage:'
    echo '    gitignore $file_type'
    echo ''
    echo '    file types:'
    # find "${trp_base_gitextensions_dir}" -type d -not -name 'ignores' -exec basename {} \; | xargs printf "    - %s\n"
    find "${trp_base_gitextensions_dir}" -type f -exec basename {} \; | xargs printf "    - %s\n"
    return 0
  fi

  file_type="${1}"
  ft_ignore_file="${trp_base_gitextensions_dir}/${file_type}"

  [ ! -f "${ft_ignore_file}" ] && echo ".gitignore file missing at ${ft_ignore_file}" && return 1

  # cp "${ft_ignore_file}" .
  echo "# ${file_type}"   >> .gitignore
  cat "${ft_ignore_file}" >> .gitignore
  echo ""                 >> .gitignore
  echo "copied .gitignore template from ${ft_ignore_file}"
}
