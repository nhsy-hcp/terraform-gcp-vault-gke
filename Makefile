.PHONY: all init tf k8s plan output destroy fmt clean benchmark

init: fmt
	@terraform init

all: gke vault-install

fmt:
	@terraform fmt -recursive

gke: init
	@terraform validate
	@terraform apply -auto-approve -var create_k8s=false

vault-install: init
	@terraform apply -auto-approve
	@./scripts/00_gke.sh

benchmark: init
	@terraform validate
	@terraform apply -auto-approve

plan: init
	@terraform validate
	@terraform plan -var create_k8s=false

output:
	@terraform output

destroy: init vault-uninstall
	@terraform destroy -auto-approve -var create_k8s=false -target google_container_cluster.gke_autopilot
	@terraform destroy -auto-approve -var create_k8s=false

vault-init:
	@./scripts/10_vault_init.sh
	@./scripts/20_vault_status.sh

vault-reinstall: vault-uninstall vault-install

vault-purge:
	-@helm uninstall vault -n vault
	-@kubectl delete pvc -n vault --all

vault-uninstall:
	@terraform destroy -auto-approve -var create_k8s=false -target module.k8s.helm_release.vault[0]
	@terraform destroy -auto-approve -var create_k8s=false -target module.k8s

vault-events:
	@kubectl get events -n vault -w

vault-logs:
	@kubectl wait --for=jsonpath='{.status.phase}'=Running pod --all --namespace vault --timeout=5m
	@kubectl logs -n vault -l app.kubernetes.io/name=vault -f

vault-curl:
	@while true;do curl -svI $(shell terraform output -raw vault_url); sleep 5; done

vault-status:
	@./scripts/20_vault_status.sh

helm-setup:
	@helm repo add hashicorp https://helm.releases.hashicorp.com
	@helm search repo hashicorp/vault

clean:
	-@rm -f terraform.tfstate*
	-@rm -f .terraform.lock.hcl
	-@rm -rf .terraform
	-@rm -rf vault-init.json
