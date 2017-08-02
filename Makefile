SHELL := /bin/bash
ALIAS = "android"
EXISTS := $(shell docker ps -a -q -f name=$(ALIAS))
RUNNED := $(shell docker ps -q -f name=$(ALIAS))
ifneq "$(RUNNED)" ""
IP := $(shell docker inspect $(ALIAS) | grep "IPAddress\"" | head -n1 | cut -d '"' -f 4)
endif
STALE_IMAGES := $(shell docker images | grep "<none>" | awk '{print($$3)}')
EMULATOR ?= "android-25"
ARCH ?= "x86"

COLON := :

.PHONY = run kill ps

:
	@docker build -q -t mdholloway/android-emulator-debian\:latest .
	@docker images

screenshots: run
	@docker exec $(ALIAS) scripts/apps-android-wikipedia-periodic-test && cp app/screenshots/* app/screenshots-ref && git commit -a -m "Update reference screenshots\n\n"

run: clean
	@docker run -e "EMULATOR=$(EMULATOR)" -e "ARCH=$(ARCH)" -d -P --privileged --name android mdholloway/android-emulator-debian

clean: kill
	@docker ps -a -q | xargs -n 1 -I {} docker rm -f {}
ifneq "$(STALE_IMAGES)" ""
	@docker rmi -f $(STALE_IMAGES)
endif

kill:
ifneq "$(RUNNED)" ""
	@docker kill $(ALIAS)
endif

ps:
	@docker ps -a -f name=$(ALIAS)
