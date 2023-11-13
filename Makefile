
# This repo's root import path (under GOPATH).
ROOT := github.com/tensorchord/openmodelz

# Container registry for base images.
BASE_REGISTRY ?= harbor.agi.info
BASE_REGISTRY_USER ?= modelzai

# Current version of the project.
VERSION ?= $(shell git describe --always --tags --abbrev=0)
# VERSION ?= $(shell git describe --match 'v[0-9]*' --always --tags --abbrev=0)
BUILD_DATE=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_TAG=$(shell if [ -z "`git status --porcelain`" ]; then git describe --exact-match --tags HEAD 2>/dev/null; fi)
GIT_TREE_STATE=$(shell if [ -z "`git status --porcelain`" ]; then echo "clean" ; ifelse echo "dirty"; fi)
GITSHA ?= $(shell git rev-parse --short HEAD)

PLATFORM ?= linux.amd64 linux.arm64
DOT := .
SLASH := /
COMMA:= ,
EMPTY:=
SPACE:= $(EMPTY) $(EMPTY)

AGENT_GO_LDFLAGS += -s -w \
		-X $(ROOT)/autoscaler/pkg/version.version=$(VERSION) \
		-X $(ROOT)/autoscaler/pkg/version.gitCommit=$(GIT_COMMIT) \
		-X $(ROOT)/autoscaler/pkg/version.gitTreeState=$(GIT_TREE_STATE) \
		-X $(ROOT)/autoscaler/pkg/version.buildDate=$(BUILD_DATE)

AUTOSCALER_GO_LDFLAGS += -s -w \
		-X $(ROOT)/autoscaler/pkg/version.version=$(VERSION) \
		-X $(ROOT)/autoscaler/pkg/version.gitCommit=$(GIT_COMMIT) \
		-X $(ROOT)/autoscaler/pkg/version.gitTreeState=$(GIT_TREE_STATE) \
		-X $(ROOT)/autoscaler/pkg/version.buildDate=$(BUILD_DATE)

INGRESS_OPERATOR_GO_LDFLAGS += -s -w \
		-X $(ROOT)/ingress-operator/pkg/version.version=$(VERSION) \
		-X $(ROOT)/ingress-operator/pkg/version.gitCommit=$(GIT_COMMIT) \
		-X $(ROOT)/ingress-operator/pkg/version.gitTreeState=$(GIT_TREE_STATE) \
		-X $(ROOT)/ingress-operator/pkg/version.buildDate=$(BUILD_DATE)

MODELZETES_GO_LDFLAGS += -s -w \
		-X $(ROOT)/modelzetes/pkg/version.version=$(VERSION) \
		-X $(ROOT)/modelzetes/pkg/version.gitCommit=$(GIT_COMMIT) \
		-X $(ROOT)/modelzetes/pkg/version.gitTreeState=$(GIT_TREE_STATE) \
		-X $(ROOT)/modelzetes/pkg/version.buildDate=$(BUILD_DATE)

.PHONY: agent.image.push
agent.image.push: ## Build and push docker image
	$(eval PLATFORM_DOCKER=$(subst $(DOT),$(SLASH),$(PLATFORM)))
	$(eval PLATFORM_DOCKER=$(subst $(SPACE),$(COMMA),$(PLATFORM_DOCKER)))
	docker buildx build --push --platform $(PLATFORM_DOCKER) --build-arg GO_LDFLAGS="$(AGENT_GO_LDFLAGS)" -f agent/build/Dockerfile --tag ${BASE_REGISTRY}/${BASE_REGISTRY_USER}/modelz-agent:$(VERSION) .

.PHONY: autoscaler.image.push
autoscaler.image.push: ## Build and push docker image
	$(eval PLATFORM_DOCKER=$(subst $(DOT),$(SLASH),$(PLATFORM)))
	$(eval PLATFORM_DOCKER=$(subst $(SPACE),$(COMMA),$(PLATFORM_DOCKER)))
	docker buildx build --push --platform $(PLATFORM_DOCKER) --build-arg GO_LDFLAGS="$(AUTOSCALER_GO_LDFLAGS)" -f autoscaler/build/Dockerfile --tag ${BASE_REGISTRY}/${BASE_REGISTRY_USER}/modelz-autoscaler:$(VERSION) .

.PHONY: ingress-operator.image.push
ingress-operator.image.push: ## Build and push docker image
	$(eval PLATFORM_DOCKER=$(subst $(DOT),$(SLASH),$(PLATFORM)))
	$(eval PLATFORM_DOCKER=$(subst $(SPACE),$(COMMA),$(PLATFORM_DOCKER)))
	docker buildx build --push --platform $(PLATFORM_DOCKER) --build-arg GO_LDFLAGS="$(INGRESS_OPERATOR_GO_LDFLAGS)" -f ingress-operator/build/Dockerfile --tag ${BASE_REGISTRY}/${BASE_REGISTRY_USER}/ingress-operator:$(VERSION) .

.PHONY: modelzetes.image.push
modelzetes.image.push: ## Build and push docker image
	$(eval PLATFORM_DOCKER=$(subst $(DOT),$(SLASH),$(PLATFORM)))
	$(eval PLATFORM_DOCKER=$(subst $(SPACE),$(COMMA),$(PLATFORM_DOCKER)))
	docker buildx build --push --platform $(PLATFORM_DOCKER) --build-arg GO_LDFLAGS="$(MODELZETES_GO_LDFLAGS)" -f modelzetes/build/Dockerfile --tag ${BASE_REGISTRY}/${BASE_REGISTRY_USER}/modelzetes:$(VERSION) .
