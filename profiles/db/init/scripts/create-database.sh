#!/bin/bash


function create_database()
{
  [ -z "$1" ] && printf 'usage:\n  create_database $database_name\n' && return 0

  local database_name="$1"

  sudo -u postgres psql -c "CREATE DATABASE $database_name;"
}

create_database "$@"
