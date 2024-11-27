.DEFAULT_GOAL=help

create-node: ## Create a new node
	@bash ./scripts/container create \
		--docker \
		$(if $(image),--image $(image),) \
		$(if $(name),--name $(name),) \
		$(if $(port),--port $(port),)

remove-node: ## Remove a node
	@bash ./scripts/container remove \
		--docker \
		$(if $(filter true,$(all)),--all,) \
		$(if $(name),--name $(name),)

list-nodes: ## List nodes
	@bash ./scripts/container list

help: ## Show this help.
# `help' function obtained from GitHub gist: https://gist.github.com/prwhite/8168133?permalink_comment_id=4160123#gistcomment-4160123
	@echo Ansible Tests
	@echo
	@awk 'BEGIN {FS = ": .*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+(\\:[$$()% 0-9a-zA-Z_-]+)*:.*?##/ { gsub(/\\:/,":", $$1); printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
