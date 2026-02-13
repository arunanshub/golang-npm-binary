// Sync binaries to packages directory from goreleaser's dist/ directory.
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/go-playground/validator/v10"
)

type Artifact struct {
	Path   string `json:"path" validate:"required"`
	Goos   string `json:"goos" validate:"required"`
	Goarch string `json:"goarch" validate:"required"`
	Type   string `json:"type" validate:"required,oneof=Binary"`
}

var goArchToNodeArchMap = map[string]string{
	"amd64": "x64",
	"386":   "x86",
	"arm64": "arm64",
}

var goOsToNodeOsMap = map[string]string{
	"windows": "win32",
}

func main() {
	artifactsPath := flag.String("artifacts-path", "dist/artifacts.json", "The path to the artifacts.json file")
	packagesPath := flag.String("packages-path", "./packages", "The path to the packages directory")
	strict := flag.Bool("strict", true, "Whether to fail if a package directory does not exist or if an artifact is missing")
	flag.Parse()

	if *artifactsPath == "" {
		log.Fatalf("artifacts-path is required")
	}
	if *packagesPath == "" {
		log.Fatalf("packages-path is required")
	}

	artifactsBytes, err := os.ReadFile(*artifactsPath)
	if err != nil {
		log.Fatalf("Failed to read artifacts.json: %v", err)
	}

	var artifacts []Artifact
	err = json.Unmarshal(artifactsBytes, &artifacts)
	if err != nil {
		log.Fatalf("Failed to unmarshal artifacts.json: %v", err)
	}

	validate := validator.New(validator.WithRequiredStructEnabled())

	for _, artifact := range artifacts {
		if err := validate.Struct(artifact); err != nil {
			continue
		}

		nodeGoArch, ok := goArchToNodeArchMap[artifact.Goarch]
		if !ok {
			nodeGoArch = artifact.Goarch
		}

		nodeGoOs, ok := goOsToNodeOsMap[artifact.Goos]
		if !ok {
			nodeGoOs = artifact.Goos
		}

		packageName := fmt.Sprintf("cli-%s-%s", nodeGoOs, nodeGoArch)
		packagePath := filepath.Join(*packagesPath, packageName)

		if _, err := os.Stat(packagePath); os.IsNotExist(err) {
			if *strict {
				log.Fatalf("Package directory %s does not exist", packagePath)
			}
			log.Printf("Package directory %s does not exist, skipping", packagePath)
			continue
		}

		log.Printf("Package directory %s exists for %s", packagePath, artifact.Path)

		binPath := filepath.Join(packagePath, "bin")
		log.Printf("Creating bin directory %s", binPath)
		// create the bin directory in package directory if it doesn't exist
		err = os.MkdirAll(binPath, 0755)
		if err != nil {
			log.Fatalf("Failed to create bin directory: %v", err)
		}

		binFilePath := filepath.Join(binPath, "safedep")
		if artifact.Goos == "windows" {
			binFilePath = filepath.Join(binPath, "safedep.exe")
		}
		log.Printf("Copying %s to %s", artifact.Path, binFilePath)

		binFileBytes, err := os.ReadFile(artifact.Path)
		if err != nil {
			log.Fatalf("Failed to read artifact: %v", err)
		}

		err = os.WriteFile(binFilePath, binFileBytes, 0755)
		if err != nil {
			log.Fatalf("Failed to write artifact to bin directory: %v", err)
		}
	}
}
