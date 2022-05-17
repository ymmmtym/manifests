OVERLAYS = dev


.PHONY: eval eval-%
eval: $(addprefix eval-, base $(OVERLAYS))

eval-base:
	@for app in */; do echo "### $${app}base ###" ; kustomize build --enable-helm $${app}base/ | kubeval --ignore-missing-schemas --skip-kinds CustomResourceDefinition --additional-schema-locations https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master; done

eval-%:
	@for app in */; do echo "### $${app}overlays/${@:eval-%=%}/ ###" ; kustomize build --enable-helm $${app}overlays/${@:eval-%=%}/ | kubeval --ignore-missing-schemas --skip-kinds CustomResourceDefinition --additional-schema-locations https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master; done


.PHONY: build build-%
build: $(addprefix build-, base $(OVERLAYS))

build-base:
	for app in */; do kustomize build --enable-helm $${app}base/; done

build-%:
	for app in */; do kustomize build --enable-helm $${app}overlays/${@:build-%=%}/; done


.PHONY: create create-%
create: $(addprefix create-, base $(OVERLAYS))

create-base:
	for app in */; do kustomize build --enable-helm $${app}base/ | kubectl create -f -; done

create-%:
	for app in */; do kustomize build --enable-helm $${app}overlays/${@:create-%=%}/ | kubectl create -f -; done


.PHONY: apply apply-%
apply: $(addprefix apply-, base $(OVERLAYS))

apply-base:
	for app in */; do kustomize build --enable-helm $${app}base/ | kubectl apply -f -; done

apply-%:
	for app in */; do kustomize build --enable-helm $${app}overlays/${@:apply-%=%}/ | kubectl apply -f -; done


.PHONY: diff diff-%
diff: $(addprefix diff-, $(OVERLAYS))

diff-%:
	for app in */; do bash diff.sh ${@:diff-%=%} $${app}; done


.PHONY: update
update: build
	for app in */; do bash update.sh $${app}; done


.PHONY: clean
clean:
	rm -fr */base/charts/ */overlays/*/charts/
