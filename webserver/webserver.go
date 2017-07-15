package webserver

import (
	"fmt"
	"log"
	"net/http"

	"github.com/bah2830/pi_bot/pibot"
	"github.com/gorilla/mux"
)

// Start serves the main web endpoints
func Start() {
	r := mux.NewRouter()
	registerDashboard(r)
	registerAPI(r)

	s := pibot.GetSettings()

	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", s.HTTPPort), r))
}
