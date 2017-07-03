package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/bah2830/pi_bot/pibot"
	_ "github.com/kidoman/embd/host/rpi"
)

func handleCtrlC(c chan os.Signal) {
	sig := <-c

	pibot.Stop()

	fmt.Println("\nsignal: ", sig)
	os.Exit(0)
}

func main() {
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go handleCtrlC(c)

	fmt.Println("Starting pi_bot")
	pibot.Start()
}
