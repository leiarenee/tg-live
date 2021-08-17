#!/bin/bash


parent_terragrunt_dir=$1
cp -R $parent_terragrunt_dir/modules/scripts .

if [[ $k8s_dependency != false ]]
then
  cp -R $parent_terragrunt_dir/modules/terraform-deploy-yaml .
  cp -R $parent_terragrunt_dir/modules/terraform-kubernetes-yaml .
  cp $parent_terragrunt_dir/modules/terraform-kubernetes-provider/kubernetes_provider.tf .
fi
