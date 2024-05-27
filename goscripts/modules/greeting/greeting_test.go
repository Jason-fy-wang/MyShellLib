package greeting

import (
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
