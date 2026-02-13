# Build the go and js binaries for development
build-dev: build-go-dev build-js

# Build the go binary for development
build-go-dev:
    goreleaser build --clean --snapshot

# Build the js cli
build-js:
    pnpm turbo build
