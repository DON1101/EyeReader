package lib

import (
    // "fmt"
    "strings"
    "unicode/utf8"
    "github.com/astaxie/beego"
)

func Split(str string, sep string) []string {
    return strings.Split(str, sep)
}

func StringToArray(str string) []string {
    char_count := utf8.RuneCountInString(str)
    char_array := make([]string, char_count)

    count := 0
    for _, char := range str {
        char_array[count] = string(char)
        count++
    }
    return char_array
}

func init() {
    beego.AddFuncMap("split", Split)
    beego.AddFuncMap("string_to_array", StringToArray)
}
