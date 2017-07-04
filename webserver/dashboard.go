package webserver

import (
	"html/template"
	"net/http"

	"github.com/spf13/viper"
)

var templates = template.Must(template.ParseGlob("resources/web_templates/*.html"))

type details struct {
	Content string
}

type page struct {
	Title       string
	Version     string
	Favicon     string
	PageDetails interface{}
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	p := page{
		Title:       "PiBot",
		Version:     viper.GetString("pibot.version"),
		Favicon:     "/content/img/favicon.png",
		PageDetails: details{Content: "Bot controls"},
	}

	templates.ExecuteTemplate(w, "index.html", p)
}
