#!/usr/bin/env bash


overlay=$1
app=$2


TMP_DIR=$(mktemp -d)

kustomize build --enable-helm ${app}overlays/${overlay} > "${TMP_DIR}/old_manifests.yaml"
sed -i.bak -e "s/version:/# version:/g" ${app}overlays/${overlay}/kustomization.yaml
rm -fr  ${app}overlays/${overlay}/charts
kustomize build --enable-helm ${app}overlays/${overlay} > "${TMP_DIR}/new_manifests.yaml"

mv ${app}overlays/${overlay}/kustomization.yaml{.bak,}

echo "#### ${app}/overlays/${overlay} diff start ####"
diff ${TMP_DIR}/{new,old}_manifests.yaml
echo "#### ${app}/overlays/${overlay} diff end ####"

rm -fr "${TMP_DIR}"
