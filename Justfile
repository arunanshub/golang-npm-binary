# Build the go binary for development
build-go-dev:
    goreleaser build --clean --snapshot

# Build the js cli
build-js-cli:
    pnpm turbo build
