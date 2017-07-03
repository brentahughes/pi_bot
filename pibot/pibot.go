package pibot

import (
	"time"

	"fmt"

	"github.com/kidoman/embd"
)

var pins Pins

type Pins struct {
	left1, left2, right1, right2 embd.DigitalPin
}

func Start() {
	embd.InitGPIO()
	defer embd.CloseGPIO()

	setupPins()
	setPinDirection()
	runDemo()
}

func Stop() {
	pins.left1.Write(embd.Low)
	pins.left2.Write(embd.Low)
	pins.right1.Write(embd.Low)
	pins.right2.Write(embd.Low)
}

func setupPins() {
	fmt.Println("Setting up pins for motor control")

	var err error

	pins.left1, err = embd.NewDigitalPin(6)
	if err != nil {
		panic(err)
	}

	pins.left2, err = embd.NewDigitalPin(13)
	if err != nil {
		panic(err)
	}

	pins.right1, err = embd.NewDigitalPin(19)
	if err != nil {
		panic(err)
	}

	pins.right2, err = embd.NewDigitalPin(26)
	if err != nil {
		panic(err)
	}
}

func setPinDirection() {
	pins.left1.SetDirection(embd.Out)
	pins.left2.SetDirection(embd.Out)
	pins.right1.SetDirection(embd.Out)
	pins.right2.SetDirection(embd.Out)
}

func runDemo() {
	fmt.Println("Starting demo")

	for {
		pins.left1.Write(embd.High)
		pins.left2.Write(embd.Low)
		pins.right1.Write(embd.High)
		pins.right2.Write(embd.Low)

		time.Sleep(2 * time.Second)

		pins.left1.Write(embd.Low)
		pins.left2.Write(embd.High)
		pins.right1.Write(embd.Low)
		pins.right2.Write(embd.High)

		time.Sleep(2 * time.Second)
	}
}
