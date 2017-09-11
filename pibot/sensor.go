package pibot

import (
	"log"
	"time"

	"github.com/kidoman/embd"
)

// ProximitySensor represents one IR sensor for navigation
type ProximitySensor struct {
	Name    string
	Pin     embd.DigitalPin
	Trigger chan bool
}

// NewProximitySensor creates a proximity sensor for monitoring for objects
func NewProximitySensor(name string, pin int) *ProximitySensor {
	sensor := &ProximitySensor{Name: name}

	var err error
	sensor.Pin, err = embd.NewDigitalPin(pin)
	if err != nil {
		log.Fatalf("Error setting up proximity sensor %s control pins. %s", name, err)
	}

	sensor.Pin.SetDirection(embd.In)

	sensor.Trigger = make(chan bool, 1)

	go sensor.start()

	log.Printf("Started proximity sensor %s on pin %d", sensor.Name, pin)

	return sensor
}

func (s *ProximitySensor) start() {
	var previusReading bool

	for {
		value, err := s.Pin.Read()
		if err != nil {
			log.Printf("Error reading from proximity sensor %s. %s", s.Name, err)
		}

		var message bool
		if value == 1 {
			message = false
		} else {
			message = true
		}

		if message == previusReading {
			continue
		}

		previusReading = message

		select {
		case s.Trigger <- message:
		default:
		}

		log.Printf("Proximity Sensor Event on %s: %t", s.Name, message)

		time.Sleep(200 * time.Millisecond)
	}
}
