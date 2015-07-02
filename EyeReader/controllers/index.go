package controllers

import (
    "fmt"
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

    str_user_id := this.GetString("user_id")
    str_quiz_id := this.GetString("quiz_id")
    slide_answer := this.GetString("slide_answer")
    var user_id int64
    var quiz_id int64
    var user models.User
    var quiz models.Quiz
    var err error

    timestamp := lib.MakeTimestamp()
    image_file := fmt.Sprintf("/tmp/eyes.%d", timestamp)
    this.SaveToFile("original", image_file)

    /***************************************
     Read initial user or create a new user.
    ****************************************/
    if user_id, err = lib.StringToInt64(str_user_id); err != nil {
        user = models.User{Id: 1} // Initial user
        if created, id, err := o.ReadOrCreate(&user, "Id"); err == nil {
            user_id = id
            beego.Info(user_id)
            if created {
                beego.Info(fmt.Sprintf("User %d created.", id))
            }
        }
    } else {
        user = models.User{Id: user_id}
    }

    /**********************
     Read or create a Quiz.
    ***********************/
    if quiz_id, err = lib.StringToInt64(str_quiz_id); err != nil {
        quiz = models.Quiz{User: &user}
        if id, err := o.Insert(&quiz); err == nil {
            quiz_id = id
            beego.Info(fmt.Sprintf("Quiz %d created.", id))
        } else {
            beego.Error(err)
        }
    } else {
        quiz = models.Quiz{Id: quiz_id}
    }

    /**********************
     Always create a Slide.
    ***********************/
    slide := models.Slide{Quiz: &quiz,
                          Answer: slide_answer,
                          EyesImage: image_file}

    if id, err := o.Insert(&slide); err == nil {
        beego.Info(fmt.Sprintf(
            "Slide %d created with answer '%s', image_file %s",
            id,
            slide_answer,
            image_file))
    } else {
        beego.Error(err)
    }

    /*************************
     Return Json data to Ajax
    **************************/
    response_json := struct {
        UserId int64
        QuizId int64
    } {user_id, quiz_id}
    this.Data["json"] = &response_json
    this.ServeJson()
}
