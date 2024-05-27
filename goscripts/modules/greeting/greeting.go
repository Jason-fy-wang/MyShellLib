package greeting

import (
	"errors"
	"fmt"
	"math/rand"
)

func Hello(name string) (string, error) {

	if name == "" {
		return "", errors.New("Empty name")
	}

	message := fmt.Sprintf(RandomFormat(), name)

	return message, nil
}

func RandomFormat() string {
	formats := []string{
		"你好, %v, 这是GO",
		"Hello, %v, this is GO",
		"Nice, %v, this is from GO",
	}

	return formats[rand.Intn(len(formats))]
}

func Hellos(names []string) (map[string]string, error) {
	messages := make(map[string]string)

	for _, name := range names {
		msg, err := Hello(name)

		if err != nil {
			return nil, err
		}
		messages[name] = msg
	}

	return messages, nil
}
