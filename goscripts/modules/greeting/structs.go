package greeting

import (
	"encoding/json"
	"fmt"
	"log"
)

type Person struct {
	Name string `json:"name"`
	Age  int    `json:"age"`
}

type Student struct {
	Person
	Cls int `json:"cls"`
}

func (p *Person) ToString() string {
	return fmt.Sprintf("%v, %v", p.Name, p.Age)
}

func init() {
	log.SetPrefix("structs ")
	log.SetFlags(log.LstdFlags | log.Lmicroseconds)
}

func StructsExm() {

	var pp Person = Person{
		Name: "Zhuli",
		Age:  10,
	}
	log.Println(pp.ToString())
	blob, err := json.Marshal(pp)

	if err != nil {
		log.Fatalln(err)
	}

	log.Println(string(blob))
}
