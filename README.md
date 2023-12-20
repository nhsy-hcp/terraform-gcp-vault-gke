# terraform-gcp-vault-gke
This repository contains an example terraform deployment for a HashiCorp Vault cluster on GKE Autopilot.

## Pre-requisites
- A sandbox Google Cloud project with owner IAM permissions
- CloudDNS manage zone with delegation to the sandbox project

## Architecture
The following resources are created:
- Google Network
- Google GKE Autopilot cluster
- Google Cloud Armor security policy 
- Google Cloud DNS record
- Google Cloud Load Balancer
- Vault helm chart

## Setup
The following tools are required to run this example:
- curl
- git
- Google Cloud SDK + gke-gcloud-auth-plugin
- helm
- jq
- kubectl
- Makefile
- Terraform

Google Cloudshell has the necessary tools installed to run this example and can be accessed by the URL below.
https://shell.cloud.google.com/?show=terminal

Open the Google Cloudshell terminal and set the project if not already set:
```bash
gcloud config set project _project_id_
gcloud auth list
```

Clone the repo and change to the folder:
```bash

git clone https://github.com/nhsy-hcp/terraform-gcp-vault-gke.git
cd terraform-gcp-vault-gke
```
Create a file named `terraform.tfvars` with the following variables and set values accordingly:
```hcl
project = "my-vault-project"
region  = "europe-west1"
dns_managed_zone_name = "my-dns-zone"
vault_fqdn = "vault.example.com"
```

## Deployment
Add the Hashicorp helm repository verify it is working:
```bash
make helm-setup
````

Deploy the GKE Autopilot cluster and HashiCorp Vault helm chart:
```bash
make init
make gke
make vault-install
```
The output of the above command should be similar to the below:
```bash
Outputs:

gke_cluster_name = "vault-autopilot-knupw"
project = "vault-autopilot"
region = "europe-west1"
vault_fqdn = "vault.example.com"
vault_ip_address = "x.x.x.x"
vault_url = "https://vault.example.com"

Fetching cluster endpoint and auth data.
kubeconfig entry generated for gke-autopilot-knupw.
Kubernetes control plane is running at https://x.x.x.x
GLBCDefaultBackend is running at https://x.x.x.x/api/v1/namespaces/kube-system/services/default-http-backend:http/proxy
KubeDNS is running at https://x.x.x.x/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://x.x.x.x/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## Initialize HashiCorp Vault Cluster
Automatically initialize the Hashicorp Vault cluster:
```bash
make vault-init
```
The output of the above command should be similar to the below:
```bash
pod/vault-0 condition met
pod/vault-1 condition met
pod/vault-2 condition met
...
...
...
{"initialized":true,"sealed":false,"standby":false,"performance_standby":false,"replication_performance_mode":"disabled","replication_dr_mode":"disabled","server_time_utc":1702926169,"version":"1.15.4","cluster_name":"vault-cluster-1d3bdd59","cluster_id":"8fa6f6cf-e9f8-0ee6-4d03-b6d0a051f6b2"}
* Connection #0 to host vault.example.com left intact

Node       Address                        State       Voter
----       -------                        -----       -----
vault-0    vault-0.vault-internal:8201    leader      true
vault-1    vault-1.vault-internal:8201    follower    true
vault-2    vault-2.vault-internal:8201    follower    false

VAULT_ADDR: https://vault.example.com
VAULT_TOKEN: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

## Troubleshooting
In another terminal, watch the Hashicorp Vault namespace events:
```bash
make vault-events
```
In another terminal, watch the Hashicorp Vault pod logs:
```bash
make vault-logs
```
In another terminal, curl the Hashicorp Vault endpoint:
```bash
make vault-curl
```

## Cleanup
Destroy the Hashicorp Vault and GKE autopilot cluster deployment:
```bash
make destroy
```

## Vault Enterprise Edition
You can deploy Vault Enterprise Edition by settings the following values in `terraform.tfvars`:
```hcl
vault_license     = "_LICENSE-STRING_"
vault_repository  = "hashicorp/vault-enterprise"
vault_version_tag = "1.15.4-ent"
```
## Known Issues
The [vault deployment](modules/k8s/main.tf) uses the `kubernetes` terraform provider and `kubernetes_manifest` resource which requires the GKE cluster to be available during `terraform plan` & `terraform apply`.

These issues will be resolved in the future by using the terraform stacks features, in the interim a [Makefile](Makefile) provides a workaround by adopting a two stage deployment process.
```hcl
│ Error: Failed to construct REST client
│ 
│   with module.k8s.kubernetes_manifest.vault_backend_config[0],
│   on modules/k8s/main.tf line 85, in resource "kubernetes_manifest" "vault_backend_config":
│   85: resource "kubernetes_manifest" "vault_backend_config" {
│ 
│ cannot create REST client: no client config

╷
│ Error: Failed to construct REST client
│ 
│   with module.k8s.kubernetes_manifest.vault_managed_cert[0],
│   on modules/k8s/main.tf line 95, in resource "kubernetes_manifest" "vault_managed_cert":
│   95: resource "kubernetes_manifest" "vault_managed_cert" {
│ 
│ cannot create REST client: no client config
╵
```
