package settings

import (
	"encoding/json"
	"log"
	"net"

	"github.com/bah2830/pi_bot/pibot/database"
)

var settings *Settings

// Settings is the settings for the whole bot
type Settings struct {
	HTTPPort  int                     `json:"httpPort"`
	Motors    map[string]MotorSetting `json:"motors"`
	Sensors   map[string]int          `json:"sensors"`
	I2CBoards []I2CBoardSetting       `json:"i2c_boards"`
}

// MotorSetting is the settings for the motor controller for each output
type MotorSetting struct {
	I2CBoardID string `json:"i2c_board_name"`
	Pins       []int  `json:"pins"`
}

// I2CBoardSetting is the settings for the i2c pwm modules
type I2CBoardSetting struct {
	ID      string `json:"id"`
	Address byte   `json:"address"`
}

// Save stores the settings in the database
func (s *Settings) Save() {
	db := database.GetDatabaseClient()
	db.Open("settings")
	defer db.Close()

	encoded, err := json.Marshal(s)
	if err != nil {
		log.Fatalf("Error saving settings. %s", err)
	}

	err = db.Put("settings", encoded)
	if err != nil {
		log.Printf("Error saving settings, %s", err)
	}

	settings = s
}

// GetSettings returns the setting struct from the database
func GetSettings() *Settings {
	if settings != nil {
		return settings
	}

	db := database.GetDatabaseClient()
	db.Open("settings")
	defer db.Close()

	var s *Settings
	json.Unmarshal([]byte(db.Get("settings")), &s)

	// Default the values
	if s == nil {
		settings = &Settings{
			HTTPPort: 8888,
			Motors: map[string]MotorSetting{
				"left": MotorSetting{
					I2CBoardID: "main",
					Pins:       []int{6, 13},
				},
				"right": MotorSetting{
					I2CBoardID: "main",
					Pins:       []int{19, 26},
				},
			},
			Sensors: map[string]int{
				"front_left":  12,
				"front_right": 16,
				"back_left":   20,
				"back_right":  21,
			},
			I2CBoards: []I2CBoardSetting{
				I2CBoardSetting{ID: "main", Address: 0x40},
			},
		}
	} else {
		settings = s
	}

	return settings
}

// PrintStartupDetails sends starupt info to stdout
func PrintStartupDetails() {
	s := GetSettings()
	addrs, err := net.InterfaceAddrs()
	if err == nil {
		for _, a := range addrs {
			if ipnet, ok := a.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
				if ipnet.IP.To4() != nil {
					log.Printf("Available at http://%s:%d\n", ipnet.IP.String(), s.HTTPPort)
					return
				}
			}
		}
	}
}
