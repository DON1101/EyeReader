package main

import (
    "github.com/astaxie/beego"
    "github.com/astaxie/beego/orm"
    _ "github.com/lib/pq"

    "EyeReader/controllers"
)

func init() {
    orm.RegisterDriver("postgres", orm.DR_Postgres)
    orm.RegisterDataBase("default", "postgres", "deveteam:@/eyes_reader?sslmode=verify-full")
    SyncDB()
}

func main() {
    beego.Router("/", &controllers.IndexController{})
    beego.Run()
}

func SyncDB() {
    // Database alias.
    name := "default"

    // Drop table and re-create.
    force := true

    // Print log.
    verbose := true

    // Error.
    err := orm.RunSyncdb(name, force, verbose)
    if err != nil {
        beego.Error(err)
    }
}

