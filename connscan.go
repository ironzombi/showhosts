package main

/* list connected hosts */
import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func hexToIP(hex string) string {
	return fmt.Sprintf("%d.%d.%d.%d",
		parseHexByte(hex[6:8]),
		parseHexByte(hex[4:6]),
		parseHexByte(hex[2:4]),
		parseHexByte(hex[0:2]),
	)
}

func parseHexByte(s string) int {
	val, _ := strconv.ParseInt(s, 16, 0)
	return int(val)
}

func hexToPort(hex string) int {
	port, _ := strconv.ParseInt(hex, 16, 0)
	return int(port)
}

func main() {
	data, err := os.ReadFile("/proc/net/tcp")
	if err != nil {
		fmt.Println("Error reading /proc/net/tcp:", err)
		os.Exit(1)
	}

	lines := strings.Split(string(data), "\n")[1:]
	for _, line := range lines {
		fields := strings.Fields(line)
		if len(fields) < 3 {
			continue
		}

		remoteHex := strings.Split(fields[2], ":")
		if len(remoteHex) < 2 {
			continue
		}

		remoteIP := hexToIP(remoteHex[0])
		remotePort := hexToPort(remoteHex[1])
		state := fields[3]

		if state == "01" { // ESTABLISHED
			fmt.Printf("%s:%d\n", remoteIP, remotePort)
		}
	}
}
