package main

import (
	"os"
	"os/signal"
	"syscall"

	"github.com/bah2830/pi_bot/pibot"
)

func handleCtrlC(c chan os.Signal) {
	<-c
	pibot.Stop()
	os.Exit(0)
}

func main() {
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go handleCtrlC(c)

	pibot.Start()
}
