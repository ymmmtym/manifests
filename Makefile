.PHONY: build
build:
	for app in */; do kustomize build --enable-helm $${app}base/;done

.PHONY: create
create:
	for app in */; do kustomize build --enable-helm $${app}base/ | kubectl create -f -; done

.PHONY: apply
apply:
	for app in */; do kustomize build --enable-helm $${app}base/ | kubectl apply -f -; done

.PHONY: diff-dev
diff-dev:
	for app in */; do bash diff.sh dev $${app}; done

.PHONY: update
update: build
	for app in */; do bash update.sh $${app}; done

.PHONY: clean
clean:
	rm -fr */base/charts/ */overlays/*/charts/
