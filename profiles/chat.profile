#!/bin/bash

[ -f $HOME/.chat/.env ] && source $HOME/.chat/.env
[ -f $HOME/.chat/.secrets/.env ] && source $HOME/.chat/.secrets/.env

function fj() {
  # uh, id, Friend-Hop, who cares, land on the 'h' so you can hey...
  cd $HOME/source/chatgpt/help
}

function gochat() {
  if [ "$1" == '.' ]; then
    cd $HOME/source/chatgpt/chat
  else
    cd $HOME/source/chatgpt
  fi
}

function chat() {
#   # if conda is not activated to `ml-base` environment, print error and exit
#   if [ -z "$CONDA_DEFAULT_ENV" ] || [ "$CONDA_DEFAULT_ENV" != "ml-base" ]; then
#     echo "`ml-base` conda env not active run     conda activate ml-base"
#     return 0
#   fi
#
#   i think that ^^^ was only required for ... making sure we have py3? idk

  python3 $HOME/source/chatgpt/chat/src/chat.py "$@"
}

function hey() {
  chat hey "$@"
}
function and() {
  chat and "$@"
}
function ok() {
  # idk alias here bc why not, feels more natural to `ok` sometimes i suppose
  chat and "$@"
}
function so() {
  chat so "$@"
}


function lastchat() {
  # todo: this should be in python, booo
  local_usage="lastchat
  options:
  -f|--file <file>     -  specify chat file to use
  -t|--thread <thread> -  specify thread to use
  -h|--help            -  print this help message
"

  while [ "$1" != "" ]; do
    case $1 in
      -f | --file ) shift
        local chat_file="$HOME/.chat/threads/$1.json"
        ;;
      -t | --thread ) shift
        local thread=$1
        ;;
      -h | --help ) echo "$local_usage"
        return 0
        ;;
      * ) echo "$local_usage"
        return 0
    esac
    shift
  done

  if [ -z "$chat_file" ]; then
    local chat_file=$HOME/.chat/threads/none.json
  fi

  if [ -z "$thread" ]; then
    echo "nothread: chatfile: $chat_file"
    jq ".threads[$(jq '.threads | keys | map(tonumber) | max | tostring' $chat_file)]" "$chat_file"
  else
    local thread_count=$(jq '.threads | keys | map(tonumber) | max' $chat_file)
    # target key is thread_count + $thread
    local target_key=$(($thread_count + $thread))
    jq ".threads[\"$target_key\"]" "$chat_file"
  fi

}

# helpers for lazy fingers (hlf)
alias clast='chat last --no-color'



#########   NEW [2024-01-26 Fri 17:35:00] BCHAT SHIT FOR BRIDGE, LANGCHAIN, LE-EVOLUTION #########

# all hardcoded for now, we config later when we have the builder system to build the buildings
RECKON_CHAT_ROOT_DIR=/home/ghostlapdev/source/projs/reckon/services/bridge/wk04

bchat() {
  $RECKON_CHAT_ROOT_DIR/scripts/chat.sh "$@"
}
