package main

import (
    "github.com/astaxie/beego"
    "EyeReader/controllers"
)

func main() {
    beego.Router("/", &controllers.IndexController{})
    beego.Run()
}

