#!/bin/bash
#set -x

export VAULT_ADDR=$(terraform output -raw vault_url)
export VAULT_TOKEN=$(cat vault-init.json | jq -r '.root_token')

kubectl exec -n vault -ti vault-0 -- vault status
kubectl exec -n vault -ti vault-1 -- vault status
kubectl exec -n vault -ti vault-2 -- vault status
kubectl exec -n vault -ti vault-0 -- sh -c "VAULT_TOKEN=$VAULT_TOKEN vault operator raft list-peers"
echo
curl -skv $VAULT_ADDR/v1/sys/health
echo
echo "VAULT_ADDR: $VAULT_ADDR"
echo "VAULT_TOKEN: $VAULT_TOKEN"
