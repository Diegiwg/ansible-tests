.PHONY: ansible container docker molecule help
.DEFAULT_GOAL=help

ansible: ## Run ansible utils    ❯ make ansible   [cmd] [args]
	@bash ./bin/ansible \
		$(if $(cmd),$(cmd),) \
		$(if $(args),$(args),)

container: ## Run container utils  ❯ make container [cmd] [args]
	@bash ./bin/container \
		$(if $(cmd),$(cmd),) \
		$(if $(args),$(args),)

docker: ## Run docker utils     ❯ make docker    [cmd] [image]
	@bash ./bin/docker \
		$(if $(cmd),$(cmd),) \
		$(if $(image),--name $(image),)

molecule: ## Run molecule utils   ❯ make molecule  [test]
	@bash ./bin/molecule \
		$(if $(test),test --name $(test),)

help: ## Show this help       ❯ make help
# `help' function obtained from GitHub gist: https://gist.github.com/prwhite/8168133?permalink_comment_id=4160123#gistcomment-4160123
	@echo Ansible Tests
	@echo
	@awk 'BEGIN {FS = ": .*##"; printf "Usage:\n"} /^[$$()% 0-9a-zA-Z_-]+(\\:[$$()% 0-9a-zA-Z_-]+)*:.*?##/ { gsub(/\\:/,":", $$1); printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)
