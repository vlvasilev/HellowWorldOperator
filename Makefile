VERSION                                 := $(shell cat VERSION)
REGISTRY                                ?= hisshadow85
HELLO_WORLD_OPERATOR_IMAGE_REPOSITORY   := $(REGISTRY)/hello-world-operator
IMAGE_TAG                               ?= $(VERSION)
NAMESPACE                               ?= default

.PHONY: run
run:
	@kopf run ./swarz.py

.PHONY: install
install:
	@helm template ./charts/crd | kubectl apply -f -

.PHONY: deploy
deploy:
	@helm template --namespace=$(NAMESPACE) \
	--set image=$(HELLO_WORLD_OPERATOR_IMAGE_REPOSITORY):$(IMAGE_TAG) \
	./charts/operator | kubectl apply -f -

.PHONY: clean
clean:
	@helm template --namespace=$(NAMESPACE) ./charts/operator | kubectl delete -f -

.PHONY: docker-images
docker-images:
	@docker build -t $(HELLO_WORLD_OPERATOR_IMAGE_REPOSITORY):$(IMAGE_TAG) -t $(HELLO_WORLD_OPERATOR_IMAGE_REPOSITORY):latest -f Dockerfile .

.PHONY: docker-push
docker-push:
	@if ! docker images $(HELLO_WORLD_OPERATOR_IMAGE_REPOSITORY) | awk '{ print $$2 }' | grep -q -F $(IMAGE_TAG); then echo "$(HELLO_WORLD_OPERATOR_IMAGE_REPOSITORY) version $(IMAGE_TAG) is not yet built. Please run 'make docker-images'"; false; fi
	@docker push $(HELLO_WORLD_OPERATOR_IMAGE_REPOSITORY):$(IMAGE_TAG)