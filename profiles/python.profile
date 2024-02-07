#!/bin/bash

[ ! -z $PYTHONPATH ] && export PYTHONPATH=$PYTHONPATH:$HOME/.local/bin || export PYTHONPATH=$HOME/.local/bin

# idk this fucks everything up now i'm running conda
alias python='python3'
alias pip='python3 -m pip'

function fetch_pypi_key()
{
  conda activate xf
  source $HOME/profiles/reckon.profile
  local healthcheck="$(reckon cli up | jq .message -r)"
  [ "$healthcheck" == "UP" ] || (echo "api not running, aborting pypi key fetch (u may have issues if you try to do pypack stuff later)" && return 0)

  export PYPI_TEST_APIKEY=$(reckon think "find % pypi test api key | props .!" | jq '.[0] | .["!"]' -r)
  conda deactivate
}
# fetch_pypi_key # don't do this it's dumb and breaks/slow/not-needed

# my neat img utils from 2023 and nfts
function get-image-info()
{
  python $HOME/profiles/python/scripts/get_image_info.py "$@"
}
function resize-image()
{
  python $HOME/profiles/python/scripts/resize.py "$@"
}
function pywatch()
{
  python $HOME/profiles/python/scripts/watch.py "$@"
}

# uh, [2024-01-25 Thu 05:22:28] happened about here with conda bullshit. seems fine tho, disable legacy (allegedly)
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# if conda active, deactivate
conda deactivate
conda activate reckon
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
