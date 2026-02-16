set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

# Verify all npm package versions are identical (no git tag required)
check-versions:
    pnpm nx run check-version-sync:check

# Verify npm package versions match the current git tag on HEAD
check-versions-strict:
    pnpm nx run check-version-sync:check-strict

# TypeScript typecheck
typecheck:
    pnpm run typecheck

# Build the go and js binaries for development
build-dev:
    pnpm run build

# Build the go and js binaries for CI/release validation
build:
    pnpm run build:strict

# Build the go binary for development
build-go-dev:
    pnpm nx run safedep-go:build-snapshot

# Build the js cli
build-js:
    pnpm nx run @test-pkg-factory/cli:build

# Sync binaries to packages directory from existing dist artifacts
sync-binaries:
    pnpm nx run sync-binaries:run-existing-dist

smoke-test:
    pnpm nx run smoke:smoke

# Full local verification: build everything then run smoke tests
verify:
    pnpm run verify

# Create a version plan (Changesets replacement)
release-plan:
    pnpm nx release plan

# Check that touched releasable projects have version plans
release-plan-check:
    pnpm nx release plan:check --base=origin/master --head=HEAD

# Bump package versions + create release tag (without publishing)
version:
    pnpm nx release version --skip-publish

# Create prerelease versions like 1.0.0-rc.0 and 1.0.0-beta.0
pre-version channel:
    pnpm nx release version prerelease --preid {{channel}} --skip-publish

# Cut a release by versioning and pushing the commit + tag to trigger release CI
release:
    #!/usr/bin/env bash
    set -euo pipefail
    pnpm nx release version --skip-publish
    git push --follow-tags
