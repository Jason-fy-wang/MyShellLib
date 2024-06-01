package main

import (
	"log"
	"net"

	"com.learn/gohttpServer/mhttp"
)

func init() {
	log.SetFlags(log.Lshortfile | log.LstdFlags)
	log.SetPrefix("starter")
}

var (
	PORT             string = "8080"
	HOST             string = "localhost"
	STATIC_DIRECTORY string = "../static"
)

func main() {
	log.Println("begin create new server")
	server, err := mhttp.NewHttpServer(PORT, HOST, STATIC_DIRECTORY)

	if err != nil {
		log.Fatalln(err)
	}

	log.Println("server init")
	server.InitHttpServer()

	log.Println("server listern: ", net.JoinHostPort(server.Host, server.Port))
	server.StartListen()
}
