#!/bin/bash

# source for new v2, global persistence type stuff
source "$HOME/.xf/.xfrc"

# from local vars
export XF_CONFIG_ROOT="$HOME/.xf"
export XF_PROJDIR="$HOME/source/trp"
export XF_BUILDDIR="$HOME/source/trp/build"
export XF_DB="context/db.json"
export XF_MIND="${XF_PROJDIR}/hq/today.xf"
export XF_MIND_DB="${XF_PROJDIR}/hq/${XF_DB}"
export XF_MIND_WEEK="${XF_PROJDIR}/hq/week.xf"
export XF_QUICKSDIR="${XF_PROJDIR}/quick/"
export XF_SYSLIVE_DIR="${XF_PROJDIR}/sys/live"
export XF_TRPRC_PATH="${XF_PROJDIR}/.trprc"

# open current mind from anywhere
alias hq="vim $XF_MIND"
alias week="vim $XF_MIND_WEEK"

# function xfdate()
# {
#   local fmt="[%Y-%m-%d %a %H:%M:%S]" 
#   PARAMS=""
#   while (( "$#" )); do
#     case "$1" in
#       -f|--format)
#         if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
#           case "$2" in
#             dotted)
#               local fmt="%Y.%m.%d %a %H:%M:%S"
#               ;;
#             # like, following <leader>dt formats here
#             dt)
#               local fmt="%Y.%m.%d"
#               ;;
#             dw)
#               local fmt="w%V"
#               ;;
#             dc)
#               local fmt="c%j"
#               ;;
#             *)
#               echo "unknown date format, must be 'dotted' or 'dashed' but got : '$2'"
#               ;;
#           esac
#           shift 2
#         else
#           echo "Error: Argument for $1 is missing" >&2
#           return 1
#         fi
#         ;;
#       -h|--help)
#         echo "usage: xfdate --format=[2022-11-28 Mon 15:57:45] (default)"
#         echo "formats:"
#         echo "  - dotted : 2022.11.28 Mon 15:55:00"
#         echo "  - dt     : 2022.11.28"
#         echo "  - dw     : w48"
#         echo "  - dc     : 332"
#         shift 1
#         return 0
#         ;;
#       -*|--*=) # unsupported flags
#         echo "Error: Unsupported flag $1" >&2
#         return 1
#         ;;
#       *) # preserve positional arguments
#         PARAMS="$PARAMS $1"
#         shift
#         ;;
#     esac
#   done
#   # set positional arguments in their proper place
#   eval set -- "$PARAMS"
# 
#   [ ! -z "$1" ] && date +"$fmt" --date="$PARAMS" \
#     || date +"$fmt"
# }
function xftoday()
{
  [ -z "$1" ] && format="dots" || format="$1"
  
  case $format in
    "dots"|"dotted"|"dot"|".")
      date +"%Y.%m.%d"
      ;;
    "dashes"|"dashed"|"dash"|"-")
      date +"%Y-%m-%d"
      ;;
    *)
      # TODO: (?) hm , just use whatever's in $1 as the separator,
      #       seems pretty neat, but later later [2022-05-10 Tue 14:05:44]
      echo "bash.xftoday: unknown format: $format"
      ;;
  esac
}
function xfweek()
{
  date +"%Y.w%W"
}

function xf()
{
  # simple history for now
  [ ! -d $HOME/.xf ] && echo '[0;30mskipping history because no ~/.xf directory exists[0;0m'

  [ -d $HOME/.xf ] \
    && printf '%s\n  | # location %s | ' "$(xfdate)" "$(pwd)" >> $HOME/.xf/history.xf \
    && printf '%s ' "$@" >> $HOME/.xf/history.xf \
    && printf '\n' >> $HOME/.xf/history.xf

  $HOME/.local/bin/xf-exe "$@"   # <- use stack installs default location
}

function xfx()
{
  xf pipe "$@"
}

# [2021-11-21 Sun 19:58:43]
# this is a temp thing that i'm like not even really using while i wait to finish persistence-structures today
function xfquick ()
{
  xf pipe -i "$XF_QUICKSDIR/context/quick.json" "$@"
}

function xfshell ()
{
  case "$1" in
    set)
      case "$2" in
        "db")
          export XF_DB="$3"
          return 0
          ;;
        *)
          export "$2"="$3"
          return 0
          ;;
      esac
      ;;
    ls)
      env | grep "^XF_" | grep "$2"
      return 0
      ;;
    *)
      printf 'usage:\n  xfshell $cmd $args\n\ncommands:\n  - set : set a config env var\n  - ls : list all XF_ env vars\n'
      return 1
      ;;
  esac
}

# no idea if this works i think it's still broken :/
function xfjson()
{
  [ -z "$1" ] && printf 'usage:\n  xfjson $filepath\n' && return 0
  filepath="$1"
  [ ! -f "$filepath" ] && printf 'file not found at %s\n' "$filepath" && return 1

  "$HOME/.trp/bin/to-json.js" "$filepath" "$(pwd)"
}

function revisit()
{
  [ -z "$1" ] && local revdate=$(xfdate -f dt) || local revdate="$1"
  xfx -i @all "find {revisit: $revdate} | wn"
}

function gm()
{

  cd "${XF_PROJDIR}/hq"
  git add .. && git commit -m "good morning"
  # remove "* today" from the top one
    # could validate somewhere too that you don't have two todays um but just don't fuck it up for a while [2021-11-23 Tue 14:25:02]
  sed 's/\(^  | \* .*\)\* today \(.*\)/\1\2/g' "$XF_MIND" >> "${XF_PROJDIR}/quick/5/5.xf"
  cd "${XF_PROJDIR}/quick/5"
  xf build
  git add . && git commit -m "commit dailies"
  cd -
  printf '%s\n\n' "$(xfdate)" > "$XF_MIND"
  xfbuild && revisit >> "$XF_MIND" || printf 'rebuild failed\n'
  # echo "  | * $(xfdots) * init" >> "$XF_MIND"
  vim "$XF_MIND" -c "normal gg xpokj dtidate kjA * today * init * health.qsl.morn __kj2o"
}

# go to trp home
function goxf()
{
  targetdir=""

  # hm [2021-12-06 Mon 08:49:36], at this point, you think you need a better system for managing this stuff? lol.

  case $1 in
    # this would be redundant, and level-1 dirs just work outta da box
    # hq)
      # targetdir=hq
      # ;;
   # but do need this cause my hq/now names are a little messy
    now)
      targetdir=hq
      ;;
    blog)
      targetdir=hq/projs/posts
      ;;
    0)
      targetdir=quick/0
      ;;
    dev)
      targetdir=quick/1
      ;;
    1)
      targetdir=quick/1
      ;;
    haskell)
      targetdir=quick/2
      ;;
    hs)
      targetdir=quick/2
      ;;
    2)
      targetdir=quick/2
      ;;
    3)
      targetdir=quick/3
      ;;
    trp)
      targetdir=quick/3
      ;;
    4)
      targetdir=quick/4
      ;;
    5)
      targetdir=quick/5
      ;;
    6)
      targetdir=quick/6
      ;;
    7)
      targetdir=quick/7
      ;;
    8)
      targetdir=quick/8
      ;;
    crypto)
      targetdir=quick/8
      ;;
    9)
      targetdir=quick/9
      ;;
    eps)
      targetdir=episodes
      ;;
    eps.1)
      targetdir=episodes/1.the-fire
      ;;
    org)
      targetdir=episodes/0.org
      ;;
    the-fire)
      targetdir=episodes/1.the-fire
      ;;
    eps.2)
      targetdir=episodes/2.liminal-states
      ;;
    liminal-states)
      targetdir=episodes/2.liminal-states
      ;;
    posts)
      targetdir=hq/projs/posts
      ;;
    *)
      targetdir="$1"
      ;;
  esac

  cd "$HOME/source/trp/$targetdir"
}

# build all shortcut
function xfbuild()
{
  cd "$XF_PROJDIR"
  ./run-build.sh
  cd -
}

function xfcat()
{
  [ -z "$1" ] && printf 'usage:\n  $xfcat $key\n'

  cat "${XF_PROJDIR}/$(xf config $1)"
}


# # helper alias fns

function dailies()
{
  xfx -i @repos.now @prog.dailies
}

function weeeek()
{
  xfx -i @repos.now @prog.week
}




# BRAINS STUFF
#    -> [2022-05-08 Sun 22:58:43]

export TRP_BRAIN_CONFIGPATH="$HOME/source/trp/sys/kvp/config.json"
export TRP_BRAIN_GLOBALPATH="$HOME/source/trp/sys/kvp/brain.json"




# look i'll find a good name at some point, going lazy for now
# (which means [2022-05-09 Mon 01:44:59] i will never clean this up ah well)
function brain()
{
  $HOME/.local/bin/brain-exe "$@" # <- use stack installs default location
}
function blast()
{
  [ -z "$2" ] && $HOME/.local/bin/brain-exe "$1" $(</dev/stdin) && return 0

  $HOME/.local/bin/brain-exe "$1" "$2" $(</dev/stdin)
}
function b()
{
  brain "$@"
}

function now()
{
  # [2022-05-09 Mon 02:34:03] -- MEGA UBER DUPER experimental,
  # mostly the "," register very very tbd, but there's not that many nice symbols you can cli
  # so maybe just don't cli it? hm.

  [ -z "$1" ] && brain items _ && return 0

  option="$1"
  if [ "$option" == "." ]; then
    brain get _ && return 0
  fi
  if [ "$option" == "help" ] || [ "$option" == "-h" ] || [ "$option" == "--help" ]; then
    printf 'usage:\n  now $option\n  options:\n'
    printf  '- [none]   : run `brain items _` to view "the now"\n'
    printf  '- .        : run `brain get _` to print the full value if ./_ is truncated\n'
    printf  '- help|-h  : print this help'
    return 0
  fi

  printf 'unknown option\n' && return 1
}

function remember_now()
{
  printf '\n%s\n\n%s\n' "$(xfdate)" "$(now)" >> $XF_MIND
}

function remember_help()
{
  printf 'usage:\n  remember $key\n\n'
  printf '  options:\n'
  printf '  -n|name    : pct name for the notion\n'
  printf '  -p|props   : star concatted strs (accepts multiple -p entries) into props str line (no #-ext support yet)\n'
  printf '  -d         : remove brain.memory entry after saving to notebook\n\n'
  return 0
}

function remember()
{
  # expand to other non-hq/today repos etc etc
  PARAMS=""
  PROPSSTR='  | * bcx'
  while (( "$#" )); do
    case "$1" in
      -d)
        local CLEARMEMORY=1
        shift
        ;;
      -n|--name)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          NAME="$2"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          return 1
        fi
        ;;
      -p|--prop|--props)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          PROPSSTR="${PROPSSTR} * $2"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          return 1
        fi
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
  # set positional arguments in their proper place
  eval set -- "$PARAMS"

  [ -z "$1" ] && remember_help && return 0
  key="$1"

  printf '\n%s\n' "$(xfdate)" >> $XF_MIND
  # use echo because percent is weird
  [ ! -z "$NAME" ] && printf '  | %% %s\n' "$NAME" >> $XF_MIND
  [ ! -z "$PROPSSTR" ] && printf '%s\n' "$PROPSSTR" >> $XF_MIND
  printf '\n%s\n\n' "$(brain is $key)" >> $XF_MIND

  if [ ! -z "$CLEARMEMORY" ]; then
    printf '  ! clearing key for %s\n' "$key"
    printf '    - %s\n' "$(brain get $key)"
    brain rm "$key"
  fi
}

function bdropkey()
{
  sed 's/.*: *//' /dev/stdin
}

function xfbash()
{
  # try string args but weird when stuff has substitutions
  # bash -c "source $HOME/.bash_profile; $( $* )"
  # require input from /std/in
  bash -c "source $HOME/.bash_profile; $(cat -)"
}
