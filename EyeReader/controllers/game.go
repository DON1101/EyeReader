package controllers

import (
    "fmt"
    "github.com/astaxie/beego"
    "github.com/astaxie/beego/orm"

    "EyeReader/lib"
    "EyeReader/models"
)

type GameController struct {
    beego.Controller
}

func (this *GameController) Get() {
    this.TplNames = "game.tpl"
    str_quiz_id := this.Ctx.Input.Param(":quiz_id")
    if quiz_id, err := lib.StringToInt64(str_quiz_id); err == nil {
        o := orm.NewOrm()
        quiz := models.Quiz{Id: quiz_id}
        var slide_list []*models.Slide
        num, _ := o.QueryTable("slide").Filter("Quiz", &quiz).All(&slide_list)
        this.Data["slide_num"] = num
        this.Data["slides"] = &slide_list
        beego.Info(fmt.Sprintf("Totally %d slides.", num))
    } else {
        beego.Error(err)
    }
}

func (this *GameController) Post() {

}
