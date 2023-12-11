.PHONY: all init apply plan output destroy fmt clean benchmark

all: apply

fmt:
	@terraform fmt -recursive

init: fmt
	@terraform init

apply: init
	@terraform validate
	@terraform apply -auto-approve
	@./scripts/00_gke.sh

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

vault-init:
	@./scripts/10_vault_init.sh

vault-reinstall: vault-uninstall apply

vault-purge:
	-@helm uninstall vault -n vault
	-@kubectl delete pvc -n vault --all
#	-@kubectl delete ns vault

vault-uninstall:
	terraform destroy -auto-approve -target 'module.k8s'

clean:
	-@rm -f terraform.tfstate*
	-@rm -rf .terraform
