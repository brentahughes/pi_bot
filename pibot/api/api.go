package api

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/bah2830/pi_bot/pibot/host"
	"github.com/bah2830/pi_bot/pibot/settings"

	"github.com/gorilla/mux"
)

// RegisterAPI sets up the routes for the api
func RegisterAPI(r *mux.Router) {
	sr := r.PathPrefix("/api").Subrouter().StrictSlash(true)

	// Handle invalid paths
	sr.NotFoundHandler = setupAPICall(http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		w.WriteHeader(404)
		w.Write([]byte(`{"message": "Not Found"}`))
	}))

	// Root path
	sr.Handle("", setupAPICall(http.HandlerFunc(apiHandler))).Methods("GET")
	sr.Handle("", setupAPICall(http.HandlerFunc(notAllowed))).Methods("POST", "PUT", "PATCH", "DELETE")

	// Host
	sr.Handle("/host", setupAPICall(http.HandlerFunc(hostHandler))).Methods("GET")
	sr.Handle("/host", setupAPICall(http.HandlerFunc(notAllowed))).Methods("POST", "PUT", "PATCH", "DELETE")

	// Settings
	sr.Handle("/settings", setupAPICall(http.HandlerFunc(apiSettingsHandler))).Methods("GET")
	sr.Handle("/settings", setupAPICall(http.HandlerFunc(notAllowed))).Methods("POST", "PUT", "PATCH", "DELETE")

	// Settings
	sr.Handle("/metrics", setupAPICall(http.HandlerFunc(metricsHandler))).Methods("GET")
	sr.Handle("/metrics", setupAPICall(http.HandlerFunc(notAllowed))).Methods("POST", "PUT", "PATCH", "DELETE")

}

func notAllowed(w http.ResponseWriter, req *http.Request) {
	w.WriteHeader(405)
	w.Write([]byte(`{"message": "Method not allowed"}`))
}

func setupAPICall(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		h.ServeHTTP(w, r) // call original
	})
}

func apiHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(`{"message": "api working"}`))
}

func hostHandler(w http.ResponseWriter, r *http.Request) {
	hostInfo := host.HostInfo

	outgoingJSON, err := json.Marshal(hostInfo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Write(outgoingJSON)
}

func apiSettingsHandler(w http.ResponseWriter, r *http.Request) {
	settings := settings.GetSettings()
	outgoingJSON, err := json.Marshal(settings)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Write(outgoingJSON)
}

func metricsHandler(w http.ResponseWriter, r *http.Request) {
	startTime := time.Now().Add(-1 * time.Hour).Format(time.RFC3339)
	metrics := host.GetHostMetricsByTime(startTime, nil)

	outgoingJSON, err := json.Marshal(metrics)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Write(outgoingJSON)
}
