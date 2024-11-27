.DEFAULT_GOAL=help

create-node: ## Create a new node
	@bash ./scripts/check-param param='$(name)' error='Please provide a node name with the name=<node_name> option'
	@bash ./scripts/check-param param='$(port)' error='Please provide a port number with the port=<port_number> option'

	@bash ./scripts/container create \
		--docker \
		$(if $(image),--image $(image),) \
		$(if $(name),--name $(name),) \
		$(if $(port),--port $(port),)

remove-node: ## Remove a node
	@bash ./scripts/check-param param='${all}${name}' error='Please provide a node name with the name=<node_name> or all=<true> option'

	@bash ./scripts/container remove \
		--docker \
		$(if $(filter true,$(all)),--all,) \
		$(if $(name),--name $(name),)

list-node: ## List nodes
	@bash ./scripts/container list

create-role: ## Create a new ansible role. 
	@bash ./scripts/check-param param='$(name)' error='Please provide a role name with the name=<role_name> option'
	
	@cd roles && ansible-galaxy role init $(name)

remove-role: ## Remove an ansible role.
	@bash ./scripts/check-param param='$(name)' error='Please provide a role name with the name=<role_name> option'
	
	@cd roles && \
		if [ -d $(name) ]; then \
			rm -rf $(name); \
			echo "Role $(name) removed successfully."; \
		else \
			echo "Role $(name) does not exist."; \
		fi

help: ## Show this help.
# `help' function obtained from GitHub gist: https://gist.github.com/prwhite/8168133?permalink_comment_id=4160123#gistcomment-4160123
	@echo Ansible Tests
	@echo
	@awk 'BEGIN {FS = ": .*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+(\\:[$$()% 0-9a-zA-Z_-]+)*:.*?##/ { gsub(/\\:/,":", $$1); printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
