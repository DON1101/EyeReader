package controllers

import (
    "fmt"
    "strconv"
    "github.com/astaxie/beego"
    "github.com/astaxie/beego/orm"

    "EyeReader/lib"
    "EyeReader/models"
)

type IndexController struct {
    beego.Controller
}

func (this *IndexController) Get() {
    this.TplNames = "index.tpl"
}

func (this *IndexController) Post() {
    this.TplNames = "index.tpl"
    o := orm.NewOrm()

    user_id := this.GetString("user_id")
    quiz_id := this.GetString("quiz_id")
    user := models.User{Id: 0}

    if user_id == "" {
        created, id, err := o.ReadOrCreate(&user, "Id"); err == nil {
            if created {
                beego.Info("User 0 created.")
            }
        }
    }

    if quiz_id == "" {
        quiz := models.Quiz{User: user}
        id, err := o.Insert(&quiz)
        if err == nil {
            beego.Info(fmt.Sprintf("Quiz %s created.", id))
        } else {
            beego.Error(err)
        }
    }

    timestamp := strconv.FormatInt(lib.MakeTimestamp(), 10)
    filename := "/tmp/eyes" + timestamp
    this.SaveToFile("original", filename)
    
    fmt.Println("Uploaded Succeed!")
}
