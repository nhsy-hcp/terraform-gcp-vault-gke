export VAULT_ADDR=$(terraform output -raw vault_url)
export VAULT_TOKEN=$(cat vault-init.json | jq -r '.root_token')

curl -sk $VAULT_ADDR/v1/sys/health
vault status
vault operator raft list-peers
echo
echo "VAULT_ADDR: $VAULT_ADDR"
echo "VAULT_TOKEN: $VAULT_TOKEN"
