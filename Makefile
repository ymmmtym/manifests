test:
	for dir in */; do kustomize build --enable-helm $${dir}base/;done

clean:
	rm -fr */base/charts/ */overlays/*/charts/
