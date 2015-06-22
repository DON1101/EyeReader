package handlers

import (
    "net/http"
    "html/template"
)

func HandleIndex(w http.ResponseWriter, r *http.Request) {
    t, _ := template.ParseFiles("templates/index.html")
    t.Execute(w, nil)
}
