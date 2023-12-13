.PHONY: all init tf k8s plan output destroy fmt clean benchmark

all: tf k8s

fmt:
	@terraform fmt -recursive

init: fmt
	@terraform init

tf: init
	@terraform validate
	@terraform apply -auto-approve -var create_k8s=false

k8s: init
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
	@terraform destroy -auto-approve -var create_k8s=false -target google_container_cluster.gke_autopilot
	@terraform destroy -auto-approve -var create_k8s=false

vault-init:
	@./scripts/10_vault_init.sh

vault-reinstall: vault-uninstall k8s

vault-purge:
	-@helm uninstall vault -n vault
	-@kubectl delete pvc -n vault --all

vault-uninstall:
	@terraform destroy -auto-approve -var create_k8s=false -target module.k8s.helm_release.vault[0]
	@terraform destroy -auto-approve -var create_k8s=false -target module.k8s

vault-curl:
	@while true;do curl -svI $(shell terraform output -raw vault_url); sleep 5; done

clean:
	-@rm -f terraform.tfstate*
	-@rm -f .terraform.lock.hcl
	-@rm -rf .terraform
	-@rm -rf vault-init.json
