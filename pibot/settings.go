package pibot

import (
	"encoding/json"

	"log"

	"github.com/bah2830/pi_bot/database"
)

// Settings is the settings for the whole bot
type Settings struct {
	HTTPPort    int
	MotorLeft1  int
	MotorLeft2  int
	MotorRight1 int
	MotorRight2 int
}

// Save stores the settings in the database
func (s *Settings) Save() {
	db := database.GetClient()
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
}

func RevertToDefault() {

}

// GetSettings returns the setting struct from the database
func GetSettings() (s *Settings) {
	db := database.GetClient()
	db.Open("settings")
	defer db.Close()

	json.Unmarshal([]byte(db.Get("settings")), &s)

	// Default the values
	if s == nil {
		return &Settings{
			HTTPPort:    8888,
			MotorLeft1:  6,
			MotorLeft2:  13,
			MotorRight1: 19,
			MotorRight2: 26,
		}
	}

	return s
}
