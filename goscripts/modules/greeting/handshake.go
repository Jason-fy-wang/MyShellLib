package greeting

import (
	"fmt"
	"log"
)

func HandShake(name string) {
	log.SetPrefix("handshake")

	msg, err := Hello(name)
	if err != nil {
		log.Fatalln(err)
	}
	fmt.Println(`greet before handshake`, msg)
	fmt.Println(` handshake....`)
}
