package pibot

import (
	"fmt"
	"time"

	"github.com/bah2830/pi_bot/pibot/settings"
	"github.com/kidoman/embd"
)

var (
	mLeft  *Motor
	mRight *Motor
)

// StartBot runs the pibot in the diseried mode. This includes setting up the gpio pins.
func StartBot(mode string) {
	embd.InitGPIO()
	defer embd.CloseGPIO()

	setupMotors()

	switch mode {
	case "demo":
		runDemo()
	default:
		fmt.Printf("PiBot mode %s unknown.\n", mode)
	}
}

// StopBot sets all pins to low to stop the motors. Used during a SIGTERM
func StopBot() {
	mLeft.Stop()
	mRight.Stop()
}

func setupMotors() {
	fmt.Println("Setting up pins for motor control")

	s := settings.GetSettings()
	mLeft = NewMotor("Left", s.MotorLeft)
	mRight = NewMotor("Right", s.MotorRight)
}

func runDemo() {
	fmt.Println("Starting demo")

	for {
		Forward()
		time.Sleep(2 * time.Second)
		Reverse()
		time.Sleep(2 * time.Second)
	}
}

// Forward calls reverse on both motors for straight forward movement
func Forward() {
	mLeft.Forward()
	mRight.Forward()
}

// Reverse calls reverse on both motors for straight backwards movement
func Reverse() {
	mLeft.Reverse()
	mRight.Reverse()
}
