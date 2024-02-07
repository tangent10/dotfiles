#!/bin/bash

export PATH="$PATH:$HOME/.xf/bin"
alias rk=reckon
alias think='reckon think'
function write-table() {
  reckon writer table --json -d - | jq .[] -r
}

#### [!INTEGRATION] source reckon env vars           ####
#### ◦ so this is where you set RECKON_ROOT_DIR etc  ####
source "$HOME/.xf/.reckonrc"

#===================================#

####################################
#           nav utils              #
####################################

function goreckon()
{
  subdir="${1:-.}" # if "$1" is null, then set subdir='.' else set subdir="$1"
  cd "$RECKON_ROOT_DIR/$subdir"
}
alias gg=goreckon

# services
function ggs()
{
  subdir="${1:-.}"
  cd "$RECKON_ROOT_DIR/services/$subdir"
}
# infra
function ggi()
{
  subdir="${1:-.}"
  cd "$RECKON_ROOT_DIR/infra/$subdir"
}
# k8s
function ggk()
{
  subdir="${1:-.}"
  cd "$RECKON_ROOT_DIR/infra/k8s/$subdir"
}
# utils
function ggu()
{
  subdir="${1:-.}"
  cd "$RECKON_ROOT_DIR/services/utils/$subdir"
}

# jump to notes (still [2023-02-06 Mon 14:23:53] very much in flux)
function goxf()
{
  subdir="${1:-.}"
  cd "$HOME/source/reckon/$subdir"
}
function now()
{
  vim $RECKON_NOTES_DIR/hq/today.xf
}

#===================================#


#####################################
#           date utils              #
#####################################

# welcome to future [2024-01-25 Thu 17:52:47]
xfdate()
{
  local fmt="[%Y-%m-%d %a %H:%M:%S]" 
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -f|--format)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          case "$2" in
            dotted)
              local fmt="%Y.%m.%d %a %H:%M:%S"
              ;;
              # like, following <leader>dt formats here
              dt)
              local fmt="%Y.%m.%d"
              ;;
            dw)
              local fmt="w%V"
              ;;
            dc)
              local fmt="c%j"
              ;;
            *)
              echo "unknown date format, must be 'dotted' or 'dashed' but got : '$2'"
              ;;
          esac
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          return 1
        fi
        ;;
      -h|--help)
        echo "usage: xfdate --format=[2022-11-28 Mon 15:57:45] (default)"
        echo "formats:"
        echo "  - dotted : 2022.11.28 Mon 15:55:00"
        echo "  - dt     : 2022.11.28"
        echo "  - dw     : w48"
        echo "  - dc     : 332"
        shift 1
        return 0
        ;;
      -*|--*=) # unsupported flags
        echo "Error: Unsupported flag $1" >&2
        return 1
        ;;
      *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
  done
  # set positional arguments in their proper place
  eval set -- "$PARAMS"

  [ ! -z "$1" ] && date +"$fmt" --date="$PARAMS" \
    || date +"$fmt"
}

#===================================#


####################################
#        run-py (quickenv)         #
####################################

function quick() {
  python "$HOME/source/repos/projs/reckon/services/utils/quick/src/app.py" "$@"
}
function quickenv() {
  python -i "$HOME/source/repos/projs/reckon/services/utils/quick/src/repl.py"
}

#===================================#

####################################
#           reckon-db              #
####################################

function reckon-db() {
[ -z "$1" ] && printf 'usage: reckon-db $query\n' && return 0
sudo -u postgres psql reckon_dev -c "$1"
}

#===================================#

####################################
#         think utils              #
####################################

alias bangnames="ack '^  \| [%\!]' --no-color"
alias bangs="ack '^  \| \!' --no-color"

#===================================#


####################################
#        bridge stuff              #
####################################

reckon_bridge_client_cli() {
  $RECKON_ROOT_DIR/services/bridge/client/run.sh "$@"
}
alias rb=reckon_bridge_client_cli
alias rkbridge=reckon_bridge_client_cli  # [2024-02-06 Tue 16:42:43] maybe pick one some day

export RECKON_BRIDGE_API_SECRET_PASSWORD='Bh77v5__!vroomski'
export RECKON_BRIDGE_API_BASEURI='https://rkutils-unitapi-qyl2d7ewea-uc.a.run.app'
function rkbridge_direct() {
  [ -z "$1" ] && printf 'usage: rkbridge_direct $endpoint:$@\n' && return 0
  curl -H "Content-Type: application/json" -H "Authorization: Bearer $RECKON_BRIDGE_API_SECRET_PASSWORD" $RECKON_BRIDGE_API_BASEURI/"$@"
}
