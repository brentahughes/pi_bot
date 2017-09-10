package pibot

import (
	"fmt"

	"github.com/bah2830/pi_bot/pibot/host"
	"github.com/bah2830/pi_bot/pibot/settings"
	"github.com/bah2830/pi_bot/pibot/webserver"
	_ "github.com/kidoman/embd/host/rpi" // Setup for the raspberry pi
)

// Version is the global version of the software
var Version = "0.1-pre-alpha"

// Start runs the main application
func Start() {
	fmt.Println("Starting pi_bot")

	host.StartHostPoller()

	StartBot("demo")

	settings.PrintStartupDetails()
	webserver.Start(Version)
}

// Stop shuts down any open channels
func Stop() {
	fmt.Println("Shutting down pi_bot")

	StopBot()
}
