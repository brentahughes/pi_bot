package pibot

import (
	"log"
	"time"

	"github.com/bah2830/pi_bot/pibot/settings"
	"github.com/kidoman/embd"
)

var (
	mLeft     *Motor
	mRight    *Motor
	pSensorFL *ProximitySensor
	pSensorFR *ProximitySensor
	pSensorBL *ProximitySensor
	pSensorBR *ProximitySensor
)

// StartBot runs the pibot in the diseried mode. This includes setting up the gpio pins.
func StartBot(mode string) {
	embd.InitGPIO()
	defer embd.CloseGPIO()

	setupMotors()
	setupProximitySensors()

	switch mode {
	case "demo":
		runDemo()
	case "default":
		runDefault()
	default:
		log.Printf("PiBot mode %s unknown.\n", mode)
	}
}

func setupProximitySensors() {
	log.Println("Setting up proximity sensors")

	s := settings.GetSettings()
	pSensorFL = NewProximitySensor("Front Left", s.Sensors["front_left"])
	pSensorFR = NewProximitySensor("Front Right", s.Sensors["front_right"])
	pSensorBL = NewProximitySensor("Back Left", s.Sensors["back_left"])
	pSensorBR = NewProximitySensor("Back Right", s.Sensors["back_right"])
}

func setupMotors() {
	log.Println("Setting up pins for motor control")

	s := settings.GetSettings()
	mLeft = NewMotor("Left", s.Motors["left"])
	mRight = NewMotor("Right", s.Motors["right"])
}

func runDefault() {
	log.Println("Starting default operation mode")

	for {
		select {
		case event := <-pSensorBR.Trigger:
			if event == true {
				Stop()
				continue
			}
			Forward()
		default:
		}
	}
}

func runDemo() {
	log.Println("Starting demo")

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

// Stop sets all pins to low to stop the motors.
func Stop() {
	mLeft.Stop()
	mRight.Stop()
}
