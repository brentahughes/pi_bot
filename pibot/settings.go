package pibot

import (
	"encoding/json"
	"log"
)

var settings *Settings

// Settings is the settings for the whole bot
type Settings struct {
	HTTPPort    int    `json:"httpPort"`
	MotorLeft   [2]int `json:"motorLeft"`
	MotorRight  [2]int `json:"motorRight"`
	SensorFront [2]int `json:"sensorFront"`
	SensorBack  [2]int `json:"sensorBack"`
}

// Save stores the settings in the database
func (s *Settings) Save() {
	db := GetDatabaseClient()
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

	db := GetDatabaseClient()
	db.Open("settings")
	defer db.Close()

	var s *Settings
	json.Unmarshal([]byte(db.Get("settings")), &s)

	// Default the values
	if s == nil {
		settings = &Settings{
			HTTPPort:    8888,
			MotorLeft:   [2]int{6, 13},
			MotorRight:  [2]int{19, 26},
			SensorFront: [2]int{12, 16},
			SensorBack:  [2]int{20, 21},
		}
	} else {
		settings = s
	}

	return s

}
