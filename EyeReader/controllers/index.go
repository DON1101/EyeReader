package controllers

import (
    "fmt"
    "strconv"
    "github.com/astaxie/beego"

    "EyeReader/lib"
)

type IndexController struct {
    beego.Controller
}

func (this *IndexController) Get() {
    this.TplNames = "index.tpl"
}

func (this *IndexController) Post() {
    this.TplNames = "index.tpl"

    timestamp := strconv.FormatInt(lib.MakeTimestamp(), 10)
    filename := "/tmp/eyes" + timestamp
    this.SaveToFile("original", filename)
    
    fmt.Println("Uploaded Succeed!")
}
