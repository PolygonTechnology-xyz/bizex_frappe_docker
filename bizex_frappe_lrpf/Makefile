ENV_FILE ?= .lrpf_env
CMP_FILE ?= lrpf.yml

.PHONY: help build up down destroy restart shell new-site install-apps bench-start

help:
	@echo "Makefile Commands:"
	@echo "  make build CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>           - Build Docker image"
	@echo "  make up CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>              - Start containers"
	@echo "  make down CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>            - Stop containers"
	@echo "  make destroy CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>         - Remove containers and volumes"
	@echo "  make restart CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>         - Restart containers"
	@echo "  make shell CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>           - Access container shell"
	@echo "  make new-site CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>        - Create new Frappe site"
	@echo "  make install-apps CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>    - Install apps"
	@echo "  make bench-start CMP_FILE=<compose_file_name> ENV_FILE=<env_file_name>     - Run bench start in container"

build:
	docker compose -f $(CMP_FILE) --env-file $(ENV_FILE) build

up:
	docker compose -f $(CMP_FILE) --env-file $(ENV_FILE) up -d

down:
	docker compose -f $(CMP_FILE) --env-file $(ENV_FILE) down

destroy:
	docker compose -f $(CMP_FILE) --env-file $(ENV_FILE) down -v

restart: down up

shell:
	docker exec -it ${CONTAINER_NAME} bash

new-site:
	docker exec -it ${CONTAINER_NAME} bash -c "\
		cd frappe-bench && \
		bench new-site ${SITE_NAME} --admin-password ${ADMIN_PASSWORD} --mariadb-root-password ${MYSQL_ROOT_PASSWORD} && \
		bench use ${SITE_NAME}"

install-apps:
	docker exec -it ${CONTAINER_NAME} bash -c "\
		cd frappe-bench && \
		for app in ${INSTALL_APPS}; do bench --site ${SITE_NAME} install-app $$app; done && \
		bench set-config -g developer_mode 1 && \
		bench set-config -g server_script_enabled 1 && \
		bench --site ${SITE_NAME} migrate"

bench-start:
	docker exec -it ${CONTAINER_NAME} bash -c "\
		cd frappe-bench && \
		bench start"
