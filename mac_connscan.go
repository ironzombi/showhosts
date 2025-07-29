package main

import (
	"fmt"

	"github.com/shirou/gopsutil/v3/net"
)

func main() {
	conns, err := net.Connections("tcp")
	if err != nil {
		panic(err)
	}

	for _, conn := range conns {
		if conn.Status == "ESTABLISHED" {
			fmt.Printf("Local: %s:%d → Remote: %s:%d\n", conn.Laddr.IP, conn.Laddr.Port, conn.Raddr.IP, conn.Raddr.Port)
		}
	}
}
