API_DIR := ../vaultshare-api

.PHONY: up down test test-coverage seed verify check format logs

up:
	$(MAKE) -C $(API_DIR) up

down:
	$(MAKE) -C $(API_DIR) down

test:
	$(MAKE) -C $(API_DIR) test

test-coverage:
	$(MAKE) -C $(API_DIR) test-coverage

seed:
	$(MAKE) -C $(API_DIR) seed

verify:
	$(MAKE) -C $(API_DIR) verify

check:
	$(MAKE) -C $(API_DIR) check

format:
	$(MAKE) -C $(API_DIR) format

logs:
	$(MAKE) -C $(API_DIR) logs
