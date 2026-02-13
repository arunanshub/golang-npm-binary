set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

# Verify all npm package versions are identical (no git tag required)
check-versions:
    go run ./scripts/check-version-sync/

# Verify npm package versions match the current git tag on HEAD
check-versions-strict:
    go run ./scripts/check-version-sync/ -require-tag

# Build the go and js binaries for development
build-dev: check-versions build-go-dev sync-binaries-dev build-js

# Build the go binary for development
build-go-dev:
    goreleaser build --clean --snapshot

# Build the js cli
build-js:
    pnpm turbo build

# Sync binaries to packages directory
sync-binaries:
    go run ./scripts/sync-binaries/ \
    -artifacts-path dist/artifacts.json \
    -packages-path packages

# Sync binaries to packages directory for development. Does not fail if a
# package directory does not exist.
sync-binaries-dev:
    go run ./scripts/sync-binaries/ \
    -artifacts-path dist/artifacts.json \
    -packages-path packages \
    -strict=false

smoke-test:
    pnpm -C packages/smoke i # ensure the package dep is in sync with the workspace
    pnpm -C packages/smoke exec safedep

# Full local verification: build everything then run smoke tests
verify: build-dev smoke-test

# Add a changeset describing your change (interactive)
changeset:
    pnpm changeset

# Bump package.json versions locally by consuming changesets (does not publish)
version:
    pnpm changeset version

# Enter pre-release mode. Subsequent `just version` calls will produce versions
# like 1.0.0-rc.0, 1.0.0-rc.1, etc. Published with --tag <channel> on npm so
# that `npm install @safedep/cli` still resolves to the latest stable release.
# Usage: just pre-enter rc   OR   just pre-enter beta
pre-enter channel:
    pnpm changeset pre enter {{channel}}

# Exit pre-release mode. The next `just version` will produce a stable version.
pre-exit:
    pnpm changeset pre exit
