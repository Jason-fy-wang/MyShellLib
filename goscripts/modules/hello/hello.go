package main

import (
	"fmt"
	"log"

	"com.learn/greeting"
)

func main() {
	log.SetPrefix("main")
	msg, err := greeting.Hello("GOScript")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(msg)

}
