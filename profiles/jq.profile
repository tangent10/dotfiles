#!/bin/bash

function jqflat() {
  jq .[] -r "$@"
}
# "JPrint"
alias jf=jqflat
