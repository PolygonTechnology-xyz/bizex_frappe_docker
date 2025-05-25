ENV_FILE ?= .env

.PHONY: help build up down destroy restart shell new-site install-apps bench-start

help:
	@echo "Makefile Commands:"
	@echo "  make build ENV_FILE=<env_file_name>           - Build Docker image"
	@echo "  make up ENV_FILE=<env_file_name>              - Start containers"
	@echo "  make down ENV_FILE=<env_file_name>            - Stop containers"
	@echo "  make destroy ENV_FILE=<env_file_name>         - Remove containers and volumes"
	@echo "  make restart ENV_FILE=<env_file_name>         - Restart containers"
	@echo "  make shell ENV_FILE=<env_file_name>           - Access container shell"
	@echo "  make new-site ENV_FILE=<env_file_name>        - Create new Frappe site"
	@echo "  make install-apps ENV_FILE=<env_file_name>    - Install apps"
	@echo "  make bench-start ENV_FILE=<env_file_name>     - Run bench start in container"

build:
	docker compose --env-file $(ENV_FILE) -f pwd.yml build

up:
	docker compose --env-file $(ENV_FILE) -f pwd.yml up -d

down:
	docker compose --env-file $(ENV_FILE) -f pwd.yml down

destroy:
	docker compose --env-file $(ENV_FILE) -f pwd.yml down -v

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
