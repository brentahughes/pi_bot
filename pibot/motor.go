package pibot

import (
	"log"

	"github.com/bah2830/pi_bot/pibot/settings"
	"github.com/kidoman/embd"
)

// Motor represents the motor for controller wheels on the pibot
type Motor struct {
	Name string
	Pins [2]embd.DigitalPin
}

// NewMotor builds a motor struct and sets up the GPIO for control.
func NewMotor(name string, motorSetting settings.MotorSetting) *Motor {
	motor := &Motor{Name: name}

	var err error

	motor.Pins[0], err = embd.NewDigitalPin(motorSetting.Pins[0])
	if err != nil {
		log.Fatalf("Error setting up %s control pins. %s", motor.Name, err)
	}

	motor.Pins[1], err = embd.NewDigitalPin(motorSetting.Pins[1])
	if err != nil {
		log.Fatalf("Error setting up %s control pins. %s", motor.Name, err)
	}

	motor.Pins[0].SetDirection(embd.Out)
	motor.Pins[1].SetDirection(embd.Out)

	return motor
}

// Forward sets the GPIO to high/low for forward rotation
func (m *Motor) Forward() {
	m.Pins[0].Write(embd.High)
	m.Pins[1].Write(embd.Low)
}

// Reverse sets the GPIO to low/high for reverse rotation
func (m *Motor) Reverse() {
	m.Pins[0].Write(embd.Low)
	m.Pins[1].Write(embd.High)
}

// Stop sets the GPIO to low/low to stop rotaion
func (m *Motor) Stop() {
	m.Pins[0].Write(embd.Low)
	m.Pins[1].Write(embd.Low)
}
