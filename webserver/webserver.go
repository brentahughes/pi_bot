package webserver

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/spf13/viper"
)

// Start serves the main web endpoints
func Start() {
	r := mux.NewRouter()
	registerDashboard(r)
	registerAPI(r)

	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", viper.GetInt("http.port")), r))
}
