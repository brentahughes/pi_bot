package webserver

import (
	"html/template"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/spf13/viper"
)

var templatePath = "resources/web_templates/"

type page struct {
	Title            string
	Version          string
	Favicon          string
	ControllerMethod string
	Data             interface{}
}

func registerDashboard(r *mux.Router) {
	r.HandleFunc("/", overviewHandler)
	r.HandleFunc("/control", controlHandler)
	r.HandleFunc("/settings", settingsHandler)

	// Setup file server for html resources
	s := http.StripPrefix("/content/", http.FileServer(http.Dir("./resources/web_content/")))
	r.PathPrefix("/content/").Handler(s)
	http.Handle("/", r)
}

func getDefaultPageData(controllerMethod string) page {
	return page{
		Title:            "PiBot",
		Version:          viper.GetString("pibot.version"),
		Favicon:          "/content/img/favicon.png",
		ControllerMethod: controllerMethod,
	}
}

func overviewHandler(w http.ResponseWriter, r *http.Request) {
	p := getDefaultPageData("overview")

	templates := template.Must(template.ParseFiles(templatePath+"layout.html", templatePath+"overview.html"))
	templates.ExecuteTemplate(w, "layout", p)
}

func controlHandler(w http.ResponseWriter, r *http.Request) {
	p := getDefaultPageData("control")

	templates := template.Must(template.ParseFiles(templatePath+"layout.html", templatePath+"control.html"))
	templates.ExecuteTemplate(w, "layout", p)
}

func settingsHandler(w http.ResponseWriter, r *http.Request) {
	p := getDefaultPageData("settings")

	templates := template.Must(template.ParseFiles(templatePath+"layout.html", templatePath+"settings.html"))
	templates.ExecuteTemplate(w, "layout", p)
}
