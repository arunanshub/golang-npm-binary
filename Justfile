# Build the go and js binaries for development
build-dev: build-go-dev sync-binaries-dev build-js

# Build the go binary for development
build-go-dev:
    goreleaser build --clean --snapshot

# Build the js cli
build-js:
    pnpm turbo build

# Sync binaries to packages directory
sync-binaries:
    go run ./scripts/sync-binaries/ \
    -artifacts-path=dist/artifacts.json \
    -packages-path=packages \

# Sync binaries to packages directory for development. Does not fail if a
# package directory does not exist.
sync-binaries-dev:
    go run ./scripts/sync-binaries/ \
    -artifacts-path=dist/artifacts.json \
    -packages-path=packages \
    -strict=false

smoke-test:
    pnpm -C packages/smoke exec safedep
