NAME=inception
COMPOSE=docker-compose -f srcs/docker-compose.yml
USERNAME=$(shell whoami)
VOLUME_PATH=/home/$(USERNAME)/data

all: up

up:
	@echo "Starting containers..."
	@$(COMPOSE) up --build -d

down:
	@echo "Stopping and removing containers..."
	@$(COMPOSE) down

prune: fclean
	@echo "Removing everything..."
	@docker system prune --all --force --volumes

re: down up

fclean:
	@echo "Full cleanup: containers, networks..."
	@$(COMPOSE) down -v --remove-orphans
	@docker rmi $(shell docker images -q --filter=reference='*inception*') 2>/dev/null || true
	@docker image prune -a -f

clean: down

.PHONY: all up down re clean fclean prune
