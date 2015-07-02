package lib

import (
    "time"
    "strconv"
    "errors"
)

func MakeTimestamp() int64 {
    return time.Now().UnixNano() / int64(time.Millisecond)
}

func StringToInt64(str string) (i int64, err error) {
    if i, err = strconv.ParseInt(str, 10, 64); err != nil {
        i = -1
        err = errors.New("Illegal string input.")
    }
    return
}
