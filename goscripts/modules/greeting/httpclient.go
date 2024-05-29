package greeting

import (
	"fmt"
	"net/http"

	"bufio"
)

func HttpClient() {
	resp, _ := http.Get("https://www.baidu.com")

	code := resp.Status

	fmt.Println("response code: ", code)

	defer resp.Body.Close()

	scan := bufio.NewScanner(resp.Body)

	for i := 0; scan.Scan() && i < 10; i++ {
		fmt.Println(scan.Text())
	}
}
