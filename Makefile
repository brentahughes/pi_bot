APP_NAME := pi_bot
PI_USER := pi
PI_ADDR := 192.168.1.198
PI_PATH := /home/pi/pibot/

SSH_BASE_CMD = $(PI_USER)@$(PI_ADDR)

remote_deploy: build upload remote_run

upload:
	chmod +x $(APP_NAME)
	rsync -avze ssh $(APP_NAME) resources $(SSH_BASE_CMD):$(PI_PATH)

remote_run: remote_kill
	ssh $(SSH_BASE_CMD) "cd $(PI_PATH) && sudo ./$(APP_NAME)"

remote_kill:
	-ssh $(SSH_BASE_CMD) sudo killall $(APP_NAME)

build:
	-rm $(APP_NAME)
	env GOARM=6 GOOS=linux GOARCH=arm go build -o $(APP_NAME) main.go
