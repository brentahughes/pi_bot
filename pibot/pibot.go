package pibot

import (
	"log"

	"github.com/bah2830/pi_bot/pibot/host"
	"github.com/bah2830/pi_bot/pibot/settings"
	"github.com/bah2830/pi_bot/pibot/webserver"
	_ "github.com/kidoman/embd/host/rpi" // Setup for the raspberry pi
)

// Version is the global version of the software
var Version = "0.1-pre-alpha"

// Start runs the main application
func Start() {
	log.Println("Starting pi_bot")

	host.StartHostPoller()

	go StartBot("default")

	settings.PrintStartupDetails()
	webserver.Start(Version)
}

// End shuts down any open channels
func End() {
	log.Println("Shutting down pi_bot")
	Stop()
}
