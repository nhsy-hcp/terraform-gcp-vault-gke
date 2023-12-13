#!/bin/bash
set -o pipefail

#kubectl wait --for=condition=PodScheduled pod --all --namespace vault --timeout=60s
kubectl wait --for=jsonpath='{.status.phase}'=Running pod --all --namespace vault --timeout=5m

sleep 3

kubectl exec -n vault -ti vault-0 -- vault status
kubectl exec -n vault -ti vault-0 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[0]')
kubectl exec -n vault -ti vault-0 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[1]')
kubectl exec -n vault -ti vault-0 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[2]')
kubectl exec -n vault -ti vault-0 -- vault status
sleep 3

kubectl exec -n vault -ti vault-1 -- vault status
kubectl exec -n vault -ti vault-1 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[0]')
kubectl exec -n vault -ti vault-1 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[1]')
kubectl exec -n vault -ti vault-1 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[2]')
kubectl exec -n vault -ti vault-1 -- vault status
sleep 3
kubectl exec -n vault -ti vault-2 -- vault status
kubectl exec -n vault -ti vault-2 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[0]')
kubectl exec -n vault -ti vault-2 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[1]')
kubectl exec -n vault -ti vault-2 -- vault operator unseal $(cat vault-init.json | jq -r '.unseal_keys_b64[2]')
sleep 3
kubectl exec -n vault -ti vault-2 -- vault status
echo
export VAULT_TOKEN=$(cat vault-init.json | jq -r '.root_token')
kubectl exec -n vault -ti vault-0 -- sh -c "VAULT_TOKEN=$VAULT_TOKEN vault operator raft list-peers"
echo
