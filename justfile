default:
    @just --list

# Start Astro Starlight dev server
dev:
    npm run dev

# Build static Starlight site into dist/
build:
    npm run build

# Preview built static site locally
preview:
    npm run preview

# Remove build and sync artifacts
clean:
    rm -rf dist .astro .cache .wrangler

# Sync upstream docs from local checkouts when present
sync:
    npm run sync

# Force sync upstream docs from GitLab/GitHub remotes
sync-remote:
    bash scripts/sync-docs.sh --remote

# Format authored files with treefmt-nix
format:
    nix fmt

# Run formatting checks, validate flake across all systems, and verify Starlight build
check:
    nix fmt -- --fail-on-change
    nix flake check --no-build --all-systems
    npm run build

# Update flake.lock
update-flake:
    nix flake update

# Update in-range npm dependencies
update-npm:
    npm update

# Check npm dependencies for high/critical vulnerabilities
audit:
    npm audit --audit-level=high
