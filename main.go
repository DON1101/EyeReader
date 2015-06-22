package main

import (
    "net/http"
    "handlers"
)

func main() {
    fs := http.FileServer(http.Dir("static"))
    http.Handle("/static/", http.StripPrefix("/static/", fs))

    http.HandleFunc("/", handlers.HandleIndex)
    http.ListenAndServe(":8080", nil)
}
