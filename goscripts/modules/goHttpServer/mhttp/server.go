package mhttp

import (
	"net"
	"net/http"
)

type Server struct {
	Port             string
	Host             string
	STATIC_DIRECTORY string
}

func NewHttpServer(port string, host string, dir string) (*Server, error) {
	server := Server{Port: port, Host: host, STATIC_DIRECTORY: dir}

	return &server, nil
}

func (s *Server) InitHttpServer() {
	http.Handle("/", http.FileServer(http.Dir(s.STATIC_DIRECTORY)))

	http.HandleFunc("/hello", Hello)
}

func (s *Server) StartListen() {
	addr := net.JoinHostPort(s.Host, s.Port)
	http.ListenAndServe(addr, nil)
}
