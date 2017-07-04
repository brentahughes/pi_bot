package webserver

import (
	"fmt"
	"net/http"
)

func apiHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "API working")
}
