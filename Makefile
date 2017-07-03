APP_NAME := pi_bot
HTTP_PORT := 8888
PI_USER := pi
PI_ADDR := 192.168.1.199
PI_PATH := /home/pi/

SSH_BASE_CMD = $(PI_USER)@$(PI_ADDR)

remote_debug: build remote_kill upload remote_run

upload:
	chmod +x $(APP_NAME)
	scp $(APP_NAME) $(SSH_BASE_CMD):$(PI_PATH)$(APP_NAME)

remote_run:
	ssh $(SSH_BASE_CMD) sudo $(PI_PATH)$(APP_NAME)

remote_kill:
	-ssh $(SSH_BASE_CMD) sudo killall $(APP_NAME)

build:
	-rm $(APP_NAME)
	env GOARM=6 GOOS=linux GOARCH=arm go build -o $(APP_NAME) main.go
