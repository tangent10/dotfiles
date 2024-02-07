#!/bin/bash

function yarnport_setport()
{
  [ "$#" -lt 3 ] && printf 'yarnport_setport requires 3 args but got fewer\n' && return 1

  local packagejson_path="$1"
  local yarnstart_old="$2"
  local target_port="$3"
  ([ ! -z "$yarnstart_old" ] && sed -i "s/\($yarnstart_old\)/PORT=$target_port \1/" "$packagejson_path") \
    || (printf 'err: jq path is empty\n' && return 2)
  }

function yarnport_clear()
{
  [ "$#" -lt 2 ] && printf 'yarnport_clear requires 2 args but got fewer\n' && return 1

  local packagejson_path="$1"
  local yarnstart_old="$2"
  ([ ! -z "$yarnstart_old" ] && sed -i "s/PORT=[0-9]\+ \(.*\)/\1/" "$packagejson_path") \
    || (printf 'err: jq path is empty\n' && return 2)
  }

function yarnport_dojq()
{
  printf 'scripts.dev: ' && jq .scripts.dev package.json && printf 'scripts.start: ' && jq .scripts.start package.json
}

function yarnport()
{
  # look at ./package.json for jq paths
  [ -z "$1" ] && yarnport_dojq && return 0

  # configure help
  case "$1" in
    h | help | -h | --help)
      printf 'usage:\n  yarnport $number $dir-prefix?\n  options:\n  --jq|-j   : the jq path (starting at .scripts, usually "start" or "dev"\n' && return 0
  esac

  # read params
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -j|--json)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          local jqpath=$2
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

  echo "jqpath : $jqpath"
  [ -z "$jqpath" ] && local jqpath="dev"
  echo "jqpath : $jqpath"

  local target_port="$1"
  [ -z "$2" ] && packagejson_path="./package.json" || packagejson_path="$2/package.json"
  [ ! -f "$packagejson_path" ] && printf 'err: no file @ %s\n' "$packagejson_path" && return 1

  local yarnstart_old=$(jq -r ".scripts.$jqpath" package.json)
  # echo "yarnstart_old :: $yarnstart_old"
  # echo "target_port  -  $target_port  -  target_port"

  ([ "$target_port" == "clear" ] && yarnport_clear "$packagejson_path" "$yarnstart_old") \
    || yarnport_setport "$packagejson_path" "$yarnstart_old" "$target_port"

  printf 'done: updated package.scripts.%s to:\n' "$jqpath"
  jq .scripts.dev package.json
}

# function js_init_project()
# {
#   [ "$#" -lt 1 ] && printf 'usage:\n  js_init_project $project_name\n' && return 0
# 
#   project_name="$1"
# 
#   mkdir $project_name
#   cd $project_name
#   yarn init -y
#   git init
#   cp $HOME/profiles/js/.gitignore .
#   sed -i 's~index.js~src/index.js~' package.json 
#   mkdir bin
#   printf '#!/usr/bin/env node\n\nconsole.log("yooo")\n' >> src/index.js
#   chmod +x ./src/index.js
#   
#   # readme
#   printf '# %s\n\nabout %s\n' $project_name $project_name > readme.md
#   git add . && git commit -m 'initial commit'
# 
#   vim readme.md
# }
# 
