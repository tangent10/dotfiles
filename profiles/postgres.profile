#!/bin/bash


function startdb()
{
  sudo service posgresql start
}

function postgres()
{
  sudo -u postgres psql "$1"
}

function query()
{
  [ -z "$1" ] && printf 'usage:\n  query $database $query\n' && return 0

  database="$1"
  query="$2"

  sudo -u postgres psql -U dev -d "$database" -c "$query"
}


# autocompletions
_query_autocomplete()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  case "${prev}" in
    "query")
      opts="portfolio reckon_dev trp"
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
      ;;
  esac
}
complete -F _query_autocomplete query
