.PHONY: all init apply plan output destroy fmt clean benchmark

all: apply

fmt:
	@terraform fmt -recursive

init: fmt
	@terraform init

apply: init
	@terraform validate
	@terraform apply -auto-approve
	@./scripts/00-gke.sh

benchmark: init
	@terraform validate
	@terraform apply -auto-approve

plan: init
	@terraform validate
	@terraform plan

output:
	@terraform output

destroy: init vault-uninstall
	@terraform destroy -auto-approve -target google_container_cluster.gke_autopilot
	@terraform destroy -auto-approve

vault-install:
	@kubectl create ns vault
	@kubectl apply -n vault -f vault/hc-vault.yaml
	@helm install vault hashicorp/vault --values=./vault/values.yaml -n vault

vault-upgrade:
	@helm upgrade vault hashicorp/vault --values=./vault/values.yaml -n vault

vault-uninstall:
	terrform destroy -auto-appprove -target 'module.k8s.kubernetes_namespace_v1.default[0]'

#vault-uninstall:
#	-@helm uninstall vault -n vault
#	-@kubectl delete pvc -n vault --all
#	-@kubectl delete ns vault

clean:
	-@rm -f terraform.tfstate*
	-@rm -rf .terraform