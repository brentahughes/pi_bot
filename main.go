package main

import (
	"fmt"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/bah2830/pi_bot/host"
	"github.com/bah2830/pi_bot/webserver"

	_ "github.com/kidoman/embd/host/rpi"
	"github.com/spf13/viper"
)

func handleCtrlC(c chan os.Signal) {
	sig := <-c

	// pibot.Stop()

	fmt.Println("\nsignal: ", sig)
	os.Exit(0)
}

func printStartupDetails() {
	addrs, err := net.InterfaceAddrs()
	if err == nil {
		for _, a := range addrs {
			if ipnet, ok := a.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
				if ipnet.IP.To4() != nil {
					fmt.Printf("Available at http://%s:%d\n", ipnet.IP.String(), viper.GetInt("http.port"))
					return
				}
			}
		}
	}
}

func loadConfig() {
	viper.SetConfigName("settings")
	viper.AddConfigPath(".")

	err := viper.ReadInConfig()
	if err != nil {
		panic(fmt.Errorf("fatal error with config file: %s", err))
	}
}

func main() {
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go handleCtrlC(c)

	fmt.Println("Starting pi_bot")
	loadConfig()

	host.StartHostPoller()

	printStartupDetails()

	webserver.Start()
}
