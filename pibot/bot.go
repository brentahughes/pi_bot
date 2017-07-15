package pibot

import (
	"fmt"
	"time"

	"github.com/kidoman/embd"
)

// StartBot runs the pibot in the diseried mode. This includes setting up the gpio pins.
func StartBot(mode string) {
	embd.InitGPIO()
	defer embd.CloseGPIO()

	loadConfiguration()

	setupPins()

	switch mode {
	case "demo":
		runDemo()
	default:
		fmt.Printf("PiBot mode %s unknown.\n", mode)
	}
}

// StopBot sets all pins to low to stop the motors. Used during a SIGTERM
func StopBot() {
	gpioPins.left1.Write(embd.Low)
	gpioPins.left2.Write(embd.Low)
	gpioPins.right1.Write(embd.Low)
	gpioPins.right2.Write(embd.Low)
}

func loadConfiguration() {
	s := GetSettings()
	motorLeftPins = s.MotorLeft
	motorRightPins = s.MotorRight
}

func setupPins() {
	fmt.Println("Setting up pins for motor control")

	var err error

	gpioPins.left1, err = embd.NewDigitalPin(motorLeftPins[0])
	if err != nil {
		panic(err)
	}

	gpioPins.left2, err = embd.NewDigitalPin(motorLeftPins[1])
	if err != nil {
		panic(err)
	}

	gpioPins.right1, err = embd.NewDigitalPin(motorRightPins[0])
	if err != nil {
		panic(err)
	}

	gpioPins.right2, err = embd.NewDigitalPin(motorRightPins[1])
	if err != nil {
		panic(err)
	}

	gpioPins.left1.SetDirection(embd.Out)
	gpioPins.left2.SetDirection(embd.Out)
	gpioPins.right1.SetDirection(embd.Out)
	gpioPins.right2.SetDirection(embd.Out)
}

func runDemo() {
	fmt.Println("Starting demo")

	for {
		gpioPins.left1.Write(embd.High)
		gpioPins.left2.Write(embd.Low)
		gpioPins.right1.Write(embd.High)
		gpioPins.right2.Write(embd.Low)

		time.Sleep(2 * time.Second)

		gpioPins.left1.Write(embd.Low)
		gpioPins.left2.Write(embd.High)
		gpioPins.right1.Write(embd.Low)
		gpioPins.right2.Write(embd.High)

		time.Sleep(2 * time.Second)
	}
}
