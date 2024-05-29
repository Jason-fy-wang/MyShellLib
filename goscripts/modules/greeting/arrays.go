package greeting

import (
	"fmt"
)

func ArrayExm() {
	fmt.Println("array function")

	arr1 := [...]int{1, 2, 3, 4, 5}

	for i, v := range arr1 {
		fmt.Println(i, v)
	}

	var arr2 [5]int

	arr2[0] = 1
	arr2[1] = 1
	arr2[2] = 1
	arr2[3] = 1

	fmt.Println(arr2)

	var arr3 [5]int = [5]int{10, 11, 12, 13, 14}
	fmt.Println(arr3)

}
