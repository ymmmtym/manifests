build:
	for dir in */; do kustomize build --enable-helm $${dir}base/;done

update: build
	for dir in */; do \
		name=$$(yq eval '.helmCharts[].name' $${dir}base/kustomization.yaml); \
		valuesFile=$$(sed -e "s/# valuesFile/valuesFile/g" $${dir}base/kustomization.yaml | yq eval '.helmCharts[].valuesFile' -); \
		cp $${dir}base/{charts/$${name}/values.yaml,$${valuesFile}}; \
	done

clean:
	rm -fr */base/charts/ */overlays/*/charts/
