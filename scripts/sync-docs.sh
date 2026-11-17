#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$ROOT_DIR/src/content/docs"
CACHE_DIR="$ROOT_DIR/.cache"

NIX_CONFIG_LOCAL="$HOME/nix-config/docs"
TEMPLATES_LOCAL="$HOME/Templates/flake-templates/docs"

use_remote=false
if [ -n "${CI:-}" ] || [ "${1:-}" = "--remote" ]; then
  use_remote=true
fi

sync_nix_config() {
  local src_dir
  if [ "$use_remote" = false ] && [ -d "$NIX_CONFIG_LOCAL" ]; then
    echo "Syncing nix-config docs from local checkout ($NIX_CONFIG_LOCAL)..."
    src_dir="$NIX_CONFIG_LOCAL"
  else
    echo "Cloning nix-config docs from GitLab..."
    rm -rf "$CACHE_DIR/nix-config"
    mkdir -p "$CACHE_DIR"
    git clone --depth 1 https://gitlab.com/kylekwong/nix-config.git "$CACHE_DIR/nix-config"
    src_dir="$CACHE_DIR/nix-config/docs"
  fi

  # Remove previous nix-config top-level docs while preserving index.md and templates/
  find "$DOCS_DIR" -mindepth 1 -maxdepth 1 ! -name 'index.md' ! -name 'templates' -exec rm -rf {} +

  for file in "$src_dir"/*; do
    local base
    base="$(basename "$file")"
    if [ "$base" = "index.md" ]; then
      cp "$file" "$DOCS_DIR/nix-config.md"
    else
      cp -r "$file" "$DOCS_DIR/$base"
    fi
  done
}

sync_flake_templates() {
  local src_dir
  if [ "$use_remote" = false ] && [ -d "$TEMPLATES_LOCAL" ]; then
    echo "Syncing flake-templates docs from local checkout ($TEMPLATES_LOCAL)..."
    src_dir="$TEMPLATES_LOCAL"
  else
    echo "Cloning flake-templates docs from GitHub..."
    rm -rf "$CACHE_DIR/flake-templates"
    mkdir -p "$CACHE_DIR"
    git clone --depth 1 https://github.com/SYKwong/flake-templates.git "$CACHE_DIR/flake-templates"
    src_dir="$CACHE_DIR/flake-templates/docs"
  fi

  rm -rf "$DOCS_DIR/templates"
  mkdir -p "$DOCS_DIR/templates"
  cp -r "$src_dir"/. "$DOCS_DIR/templates/"
}

sync_nix_config
sync_flake_templates
