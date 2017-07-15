package pibot

import (
	"fmt"
	"net"

	"github.com/kidoman/embd"
	_ "github.com/kidoman/embd/host/rpi" // Setup for the raspberry pi
)

// Version is the global verison of the software
var Version = "0.1-pre-alpha"

var gpioPins pins
var motorLeftPins [2]int
var motorRightPins [2]int

type pins struct {
	left1, left2, right1, right2 embd.DigitalPin
}

// Start runs the main application
func Start() {
	fmt.Println("Starting pi_bot")

	StartHostPoller()

	// StartBot("demo")

	printStartupDetails()
	StartWebServer()
}

// Stop shuts down any open channels
func Stop() {
	fmt.Println("Shutting down pi_bot")
}

func printStartupDetails() {
	s := GetSettings()
	addrs, err := net.InterfaceAddrs()
	if err == nil {
		for _, a := range addrs {
			if ipnet, ok := a.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
				if ipnet.IP.To4() != nil {
					fmt.Printf("Available at http://%s:%d\n", ipnet.IP.String(), s.HTTPPort)
					return
				}
			}
		}
	}
}
