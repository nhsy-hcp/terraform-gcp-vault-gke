.PHONY: all init apply plan output destroy fmt clean benchmark

all: apply

fmt:
	@terraform fmt -recursive

init: fmt
	@terraform init

apply: init
	@terraform validate
	@#terraform apply -auto-approve -var create_k8s=false
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

destroy: init
	@terraform destroy -auto-approve -var create_k8s=false -target module.k8s
	@terraform destroy -auto-approve -var create_k8s=false -target google_container_cluster.gke_autopilot
	@terraform destroy -auto-approve -var create_k8s=false

vault-init:
	@./scripts/10_vault_init.sh

vault-reinstall: vault-uninstall apply

vault-purge:
	-@helm uninstall vault -n vault
	-@kubectl delete pvc -n vault --all
#	-@kubectl delete ns vault

vault-uninstall:
	@terraform destroy -auto-approve -target 'module.k8s'

vault-curl:
	@while true;do curl -sI $(shell terraform output -raw vault_url); sleep 3; done

clean:
	-@rm -f terraform.tfstate*
	-@rm -rf .terraform
