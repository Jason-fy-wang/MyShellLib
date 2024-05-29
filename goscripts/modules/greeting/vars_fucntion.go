package greeting

import (
	"log"
)

func init() {
	log.SetPrefix("function")
	log.SetFlags(log.LstdFlags | log.Lshortfile | log.Lmicroseconds)
}

func FunctionExm(name string, args ...interface{}) {

	for arg := range args {
		log.Println(arg)
	}
}
