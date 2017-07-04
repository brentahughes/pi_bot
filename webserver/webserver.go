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

// @see dashboard.go
func registerDashboard(r *mux.Router) {
	r.HandleFunc("/", indexHandler)

	// Setup file server for html resources
	s := http.StripPrefix("/content/", http.FileServer(http.Dir("./resources/web_content/")))
	r.PathPrefix("/content/").Handler(s)
	http.Handle("/", r)
}

// @see api.go
func registerAPI(r *mux.Router) {
	sr := r.PathPrefix("/api").Subrouter()
	sr.HandleFunc("/", apiHandler)
}
