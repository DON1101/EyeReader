package handlers

import (
    "fmt"
    "net/http"
    "html/template"
)

func HandleIndex(w http.ResponseWriter, r *http.Request) {
    switch r.Method {
       case "GET":
           // Serve the resource.
       case "POST":
           r.ParseMultipartForm(32 << 20)
           file, handler, err := r.FormFile("uploadfile")
           if err != nil {
               fmt.Println(err)
               return
           }
           defer file.Close()
           fmt.Println(file.name)
           fmt.Fprintf(w, "%s", file.name)
           break
       case "PUT":
           // Update an existing record.
       case "DELETE":
           // Remove the record.
       default:
           t, _ := template.ParseFiles("templates/index.html")
           t.Execute(w, nil)
    }
}
