package greeting

import (
	"fmt"
)

func SlicesExm() {
	fmt.Printf("Slices")

	var sli []int

	for i := 0; i < 10; i++ {
		sli = append(sli, i)
	}

	fmt.Println(sli)

	// array convert to slice

	var arr [5]int = [5]int{1, 2, 3, 4, 5}
	sli2 := arr[:len(arr)]

	fmt.Printf("%T -> %T\n", arr, sli2)
}
