#!/bin/bash

function dappnew() {
  [ -z "$1" ] && printf 'usage:\n  dappnew $proj-name (dir to create)\n' && return 0
  mkdir "$1"
  cd "$1"
  dapp init
  # git init
  # need that gitignoreeeee module fuck i might just do it right now i'm so lazy for anything else
  # git add . && git commit -m "dappnew init repo"
}

function setseth() {
# touch .secrets
  cat /home/ghostlapdev/profiles/dapptools/.sethrc > .sethrc
  sed -i "s/aa=/aa=$(seth ls | head -n 1 | awk ' { print $1 }')/" .sethrc
  sed -i "s/bb=/bb=$(seth ls | head -n 2 | tail -n 1 | awk ' { print $1 }')/" .sethrc
  sed -i "s/cc=/cc=$(seth ls | head -n 3 | tail -n 1 | awk ' { print $1 }')/" .sethrc
  sed -i "s/dd=/dd=$(seth ls | head -n 4 | tail -n 1 | awk ' { print $1 }')/" .sethrc
}

function sethaddy() {
  seth ls | head -n "$1" | tail -n 1 | awk ' { print $1 }'
}

function ethgas() {
  # source $HOME/source/crypto/CHAIN/MAINNET/.sethrc
  source $HOME/source/crypto/CHAIN/MAINNET/.dapprc
  printf '%s gwei\n' "$(seth --from-wei $(seth block latest baseFeePerGas) gwei)"
}

function ethprice() {
  curl -X 'GET' \
  'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd' \
  -s -H 'accept: application/json'
}

function rpc() {
  # options:
  # - eth
  #   https://eth-mainnet.alchemyapi.io/v2/rHXuVowCG-bQH5PaUm49qMH5xOcbHRrb
  # - canto
  #   http://35.194.88.51:8545
  # - canto.slingshot
  #   https://canto.slingshot.finance/
  # - optimism
  #   https://opt-mainnet.g.alchemy.com/v2/FsHEhMu7vIatgMA9flX-hSjjcbX4SJqm
  # - arbitrum
  #   https://arb-mainnet.g.alchemy.com/v2/VE5I3sMA-kRrN2Qon8aMuBVIeSL51UXh
  # - polygon
  #   https://polygon-mainnet.g.alchemy.com/v2/CI5e7OmVCJ4PF7gSKUTt6kw_dcOid4Gm
  # - base
  #   https://base-mainnet.g.alchemy.com/v2/0STcpbarSvjyyoFQJ7Z1CC0mB1JTP6JC

  case "$1" in
    eth|ethereum)
      export ETH_RPC_URL=https://eth-mainnet.alchemyapi.io/v2/rHXuVowCG-bQH5PaUm49qMH5xOcbHRrb
      ;;
    canto)
      # export ETH_RPC_URL=https://canto.slingshot.finance/ # disabling [2023-07-03 Mon 12:34:40]
      export ETH_RPC_URL=https://canto.gravitychain.io/
      ;;
    optimism|op|opt)
      export ETH_RPC_URL=https://opt-mainnet.g.alchemy.com/v2/FsHEhMu7vIatgMA9flX-hSjjcbX4SJqm
      ;;
    arbitrum|arb)
      export ETH_RPC_URL=https://arb-mainnet.g.alchemy.com/v2/VE5I3sMA-kRrN2Qon8aMuBVIeSL51UXh
      ;;
    polygon|matic)
      export ETH_RPC_URL=https://polygon-mainnet.g.alchemy.com/v2/CI5e7OmVCJ4PF7gSKUTt6kw_dcOid4Gm
      ;;
    bsc)
      export ETH_RPC_URL=https://bsc-dataseed2.defibit.io
      ;;
    avax)
      export ETH_RPC_URL=https://api.avax.network/ext/bc/C/rpc
      ;;
    base)
      export ETH_RPC_URL=https://base-mainnet.g.alchemy.com/v2/0STcpbarSvjyyoFQJ7Z1CC0mB1JTP6JC
      ;;
    local)
      export ETH_RPC_URL=http://localhost:8545
      ;;
    *)
      printf 'RPC |%s|\n' "  ->   $(echo $ETH_RPC_URL)   <-"
      printf 'usage:\n  rpc $network\n'
      printf '  $network:\n'
      printf '    - eth\n'
      printf '    - canto\n'
      printf '    - optimism|op|opt\n'
      printf '    - arbitrum|arb\n'
      printf '    - polygon|matic\n'
      printf '    - bsc\n'
      printf '    - avax\n'
      printf '    - local\n'
      ;;
  esac
}

export TANGENT_ETH=0xCE430a6B4a21dbae8365860EAfac048989A3090F
export ETHERSCAN_API_KEY=D6IF4RGMIBIIXWERY8F994WJXT16MA2ZVG
