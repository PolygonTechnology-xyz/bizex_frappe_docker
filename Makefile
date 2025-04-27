# -----------------------------------
# Variables
# -----------------------------------
# PROJECT_NAME := frappe-dev
# SITE_NAME := site.local
# ADMIN_PASSWORD := admin
# MYSQL_ROOT_PASSWORD := root
# INSTALL_APPS := erpnext hrms hrss_app
# CONTAINER_NAME := $(PROJECT_NAME)_frappe_1

# -----------------------------------
# Commands
# -----------------------------------

.PHONY: help
help:
	@echo "Makefile Commands:"
	@echo "  make build           - Build Docker image"
	@echo "  make up              - Start containers"
	@echo "  make down            - Stop containers"
	@echo "  make restart         - Restart containers"
	@echo "  make shell           - Access container shell"
	@echo "  make new-site        - Create new Frappe site"
	@echo "  make install-apps    - Install ERPNext, HRMS, Custom App"
	@echo "  make bench-start     - Run bench start in container"

build:
	docker compose -f pwd.yml build

up:
	docker compose -f pwd.yml up -d

down:
	docker compose down -v

restart: down up

# shell:
# 	docker exec -it $(CONTAINER_NAME) bash

# new-site:
# 	docker exec -it $(CONTAINER_NAME) bash -c "\
# 		cd frappe-bench && \
# 		bench new-site $(SITE_NAME) --admin-password $(ADMIN_PASSWORD) --mariadb-root-password $(MYSQL_ROOT_PASSWORD) && \
# 		bench use $(SITE_NAME)"

# install-apps:
# 	docker exec -it $(CONTAINER_NAME) bash -c "\
# 		cd frappe-bench && \
# 		bench --site $(SITE_NAME) install-app erpnext && \
# 		bench --site $(SITE_NAME) install-app hrms && \
# 		bench --site $(SITE_NAME) install-app hrss_app && \
# 		bench set-config -g developer_mode 1 && \
# 		bench set-config -g server_script_enabled 1 && \
# 		bench --site $(SITE_NAME) migrate"

# bench-start:
# 	docker exec -it $(CONTAINER_NAME) bash -c "\
# 		cd frappe-bench && \
# 		bench start"
