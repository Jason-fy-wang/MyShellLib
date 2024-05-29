package greeting

import (
	"fmt"
	"regexp"
	"testing"
)

func TestGreeting(t *testing.T) {
	msg, err := Hello("Golbay")
	expect := regexp.MustCompile("Golbay")

	if err != nil || !expect.MatchString(msg) {
		t.Fatalf(`Hello("Golbay") = %v,%v`, msg, err)
	}

}

func TestFunction(t *testing.T) {
	fmt.Println("functional test")
	//ArrayExm()
	//SlicesExm()
	//StructsExm()
	//FunctionExm("zhangsan", 1, 2, 3, 4, 5, 6, 1, 101)
	//HttpClient()

	//HttpServerExm()

}
