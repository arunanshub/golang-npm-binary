set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

# Verify that the build is working
verify:
    pnpm nx run-many -t build verify

# Build the project
build:
    pnpm nx run-many -t build

# Build the project for production
build-prod:
    pnpm nx run-many -t build:prod
