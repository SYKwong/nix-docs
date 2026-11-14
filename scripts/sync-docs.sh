#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$ROOT_DIR/src/content/docs"
CACHE_DIR="$ROOT_DIR/.cache"

NIX_CONFIG_LOCAL="$HOME/nix-config/docs/src/content/docs"
TEMPLATES_LOCAL="$HOME/Templates/flake-templates/docs"

# Clean previously synced files while keeping the unified landing page.
find "$DOCS_DIR" -mindepth 1 -maxdepth 1 ! -name 'index.md' -exec rm -rf {} +

if [ -z "${CI:-}" ] && [ -d "$NIX_CONFIG_LOCAL" ]; then
  echo "Syncing nix-config docs from local checkout..."
  nix_config_src="$NIX_CONFIG_LOCAL"
else
  echo "Cloning nix-config docs from GitLab..."
  rm -rf "$CACHE_DIR/nix-config"
  mkdir -p "$CACHE_DIR"
  git clone --depth 1 https://gitlab.com/kylekwong/nix-config.git "$CACHE_DIR/nix-config"
  nix_config_src="$CACHE_DIR/nix-config/docs/src/content/docs"
fi

for file in "$nix_config_src"/*; do
  base="$(basename "$file")"
  if [ "$base" = "index.md" ]; then
    cp "$file" "$DOCS_DIR/nix-config.md"
  else
    cp -r "$file" "$DOCS_DIR/$base"
  fi
done

if [ -z "${CI:-}" ] && [ -d "$TEMPLATES_LOCAL" ]; then
  echo "Syncing flake-templates docs from local checkout..."
  templates_src="$TEMPLATES_LOCAL"
else
  echo "Cloning flake-templates docs from GitHub..."
  rm -rf "$CACHE_DIR/flake-templates"
  mkdir -p "$CACHE_DIR"
  git clone --depth 1 https://github.com/SYKwong/flake-templates.git "$CACHE_DIR/flake-templates"
  templates_src="$CACHE_DIR/flake-templates/docs"
fi

mkdir -p "$DOCS_DIR/templates"
cp -r "$templates_src"/. "$DOCS_DIR/templates/"
