#!/usr/bin/env bash


app=$1

# comment in `valuesFile`
IFS=''
helmCharts=$(sed -e "s/# valuesFile/valuesFile/g" "${app}base/kustomization.yaml" | yq eval '.helmCharts' -)
unset IFS

names=($(echo "${helmCharts}" | yq eval '.[].name' -))
valuesFiles=($(echo "${helmCharts}" | yq eval '.[].valuesFile' -))

for((i=0; i<${#names[@]}; i++)); do
    cp ${app}base/{charts/${names[i]}/values.yaml,${valuesFiles[i]}}
    echo -e "Updated ${names[i]} ${valuesFiles[i]} !!!"
done

