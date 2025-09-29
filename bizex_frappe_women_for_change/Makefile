ENV_FILE ?= .wfc_env
CMP_FILE ?= wfc.yml

.PHONY: help build up down destroy restart shell new-site install-apps bench-start

help:
	@echo "Makefile Commands:"
	@echo "  make build            - Build Docker image"
	@echo "  make up               - Start containers"
	@echo "  make down             - Stop containers"
	@echo "  make destroy          - Remove containers and volumes"
	@echo "  make restart          - Restart containers"
	@echo "  make shell            - Access container shell"
	@echo "  make new-site         - Create new Frappe site"
	@echo "  make install-apps     - Install apps"
	@echo "  make bench-start      - Run bench start in container"

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
