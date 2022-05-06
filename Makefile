.PHONY: build
build:
	for app in */; do kustomize build --enable-helm $${app}base/;done

.PHONY: update
update: build
	for app in */; do bash update.sh $${app}; done

.PHONY: clean
clean:
	rm -fr */base/charts/ */overlays/*/charts/
