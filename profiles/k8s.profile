#!/bin/bash

alias kj=kubectl
alias kdp='kubectl describe pod'
alias kgcm='kubectl get configMap'
alias kgd='kubectl get deployment'
alias kgi='kubectl get ingress'
alias kgp='kubectl get pods'
alias kgs='kubectl get service'
alias kl='kubectl logs'
alias kx='kubectl exec -t'

# [2022-12-11 Sun 13:02:08] disable helm for now, we're rolilng our own configs, baby
# function k8s_install_helm()
# {
#   # source: https://helm.sh/docs/intro/install/
#   curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#   chmod 700 get_helm.sh
#   ./get_helm.sh
# }

function get_pod_name()
{
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -n|--namespace)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          local namespace="$2"
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

  [ -z "$1" ] && printf 'usage:\n  get_pod_name $pod_name\n' && return 0

  local pod_name="$1"

  if [ ! -z "$namespace" ]; then
      kubectl get pods --namespace "$namespace" | ack "$pod_name" | cut -d' ' -f 1
  else
      kubectl get pods | ack "$pod_name" | cut -d' ' -f 1
  fi

}
alias pod=get_pod_name

function kubectx()
{
  kubectl config set-context --current "--namespace=$1"
}



















































function kubewait()
{
  [ -z "$1" ] && printf 'usage:\n  kubewait $pod_name\n' && return 0
  local pod_name="$1"

  while [ "$(kubectl get pods | ack "$pod_name" | awk '{print $3}')" != "Running" ]; do
    printf "waiting for pod $pod_name to start"
    sleep 1s && printf '.'
    sleep 0.5s && printf '.'
    sleep 0.5s && printf '.'
    sleep 0.5s && printf '\n'
  done
}






