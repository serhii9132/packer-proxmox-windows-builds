ENV_FILE   		:= .env
LOG_DIR    		:= logs
LOG_TIMESTAMP 	:= $(shell date +"%Y-%m-%d_%H-%M-%S")
LOAD_ENV 		:= set -a; [ -f $(ENV_FILE) ] && . ./$(ENV_FILE); set +a

.PHONY: init_logs server-22

init_logs:
	@mkdir -p $(LOG_DIR)

server-22: init_logs
	@packer init builds/server-22/main.pkr.hcl
	@$(LOAD_ENV) && \
	export PACKER_LOG_PATH="$(LOG_DIR)/server_22_build_$(LOG_TIMESTAMP).log" PACKER_LOG=1 && \
	packer build -var-file=commons.pkrvars.hcl builds/server-22/	