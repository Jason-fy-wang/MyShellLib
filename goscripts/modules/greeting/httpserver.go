package greeting

import (
	"net/http"
)

func HttpServerExm() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		w.Write([]byte("hello from go world"))
	})

	http.ListenAndServe(":8080", nil)
}
