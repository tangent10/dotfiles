#!/bin/bash

# use this to set up a symlink to the open-zeppelin directory structure so that
# it matches the directory structure dapptools expects
# from this workaround : https://github.com/dapphub/dapp/issues/70

function configure_open_zeppelin()
{
  OZ_DIR=src/lib/zeppelin-solidity/src
  GIT_DIR="./.git/modules/$OZ_DIR"

  ([ ! -d $GIT_DIR ] \
    || [ ! -d './src/lib/zeppelin-solidity' ] ) \
    && printf 'open-zeppelin submodule not found at %s\n  to use, run:\n  dapp install OpenZeppelin/zeppelin-solidity; git fetch --recurse-submodules; ./scripts/configure-open-zeppelin.sh\n' \
    && return 0

  ln -s contracts $OZ_DIR
  echo /src >> ./.git/modules/src/lib/zeppelin-solidity/info/exclude
}

configure_open_zeppelin "$@"

