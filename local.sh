#!/bin/bash

# This script launches a local k3d cluster and bootstraps ArgoCD

# Set working directory
pushd "$(dirname "$0")" > /dev/null

# Start cluster
k3d cluster create intranet-cluster

# Navigate to the ArgoCD bootstrap Terraform directory
cd argocd/

# Bootstrap ArgoCD
terraform init -upgrade
terraform apply -var-file=local.tfvars -var=skip_crds=true -auto-approve

# Add CRDs
terraform apply -var-file=local.tfvars -auto-approve

# Restore working directory
popd > /dev/null
