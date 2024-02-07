#!/bin/bash


function print_db_info()
{
  local USAGE=$(cat <<-END

  reckon.db module
  ----------------
  create the database with   :   ./scripts/create-database.sh \$name
  start postgres             :   ./scripts/start-db.sh
  connect to the db          :   ./scripts/connect.sh

  view example tables file   :   cat ./scripts/tables
END
)

  echo "$USAGE"
  echo ""

}

print_db_info "$@"
