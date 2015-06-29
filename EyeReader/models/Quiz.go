package models

import (
    "github.com/astaxie/beego/orm"
)

// Model Struct
type Quiz struct {
    Id int
    User *User `orm:"rel(fk)"` // RelForeignKey relation
}

func init() {
    // Need to register model in init
    orm.RegisterModel(new(Quiz))
}
