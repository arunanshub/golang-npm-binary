package main

import (
	"fmt"
)
var (
	Version   = "dev"
	Arch      = "unknown"
	Os        = "unknown"
	Date      = "unknown"
	Commit    = "unknown"
)

func main() {
	fmt.Println("Hello, World!")
	// get data generated from ldflags
	fmt.Println("Version:", Version)
	fmt.Println("Arch:", Arch)
	fmt.Println("Os:", Os)
	fmt.Println("Date:", Date)
	fmt.Println("Commit:", Commit)
}
