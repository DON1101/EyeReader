package models

import (
    "github.com/astaxie/beego/orm"
)

type Slide struct {
    Id int
    Quiz *Quiz `orm:"rel(fk)"` // RelForeignKey relation
    EyesImage string
    Answer string
}

func init() {
    // Need to register model in init
    orm.RegisterModel(new(Slide))
}
