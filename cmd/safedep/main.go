package main

import (
	"fmt"
	"os"
)

var (
	Version = "dev"
	Arch    = "unknown"
	Os      = "unknown"
	Date    = "unknown"
	Commit  = "unknown"
)

func main() {
	if len(os.Args) > 1 {
		switch os.Args[1] {
		case "--version", "-v", "version":
			fmt.Println(Version)
			return
		}
	}

	fmt.Println("Hello, World!")
	// get data generated from ldflags
	fmt.Println("Version:", Version)
	fmt.Println("Arch:", Arch)
	fmt.Println("Os:", Os)
	fmt.Println("Date:", Date)
	fmt.Println("Commit:", Commit)
}
