#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$ROOT_DIR/src/content/docs"
CACHE_DIR="$ROOT_DIR/.cache"

use_remote=false
if [ -n "${CI:-}" ] || [ "${1:-}" = "--remote" ]; then
  use_remote=true
fi

resolve_local_docs() {
  local candidate
  for candidate in "$@"; do
    if [ -n "$candidate" ] && [ -d "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

sync_repo() {
  local name="$1"
  local remote_url="$2"
  local target_subdir="$3"
  shift 3

  local src_dir=""
  if [ "$use_remote" = false ]; then
    src_dir="$(resolve_local_docs "$@" || true)"
  fi

  if [ -n "$src_dir" ]; then
    echo "Syncing $name docs from local checkout ($src_dir)..."
  else
    echo "Cloning $name docs from $remote_url..."
    rm -rf "${CACHE_DIR:?}/$name"
    mkdir -p "$CACHE_DIR"
    git clone --depth 1 "$remote_url" "$CACHE_DIR/$name"
    src_dir="$CACHE_DIR/$name/docs"
  fi

  rm -rf "${DOCS_DIR:?}/$target_subdir"
  mkdir -p "$DOCS_DIR/$target_subdir"
  cp -r "$src_dir"/. "$DOCS_DIR/$target_subdir/"
}

sync_repo \
  "nix-config" \
  "https://gitlab.com/kylekwong/nix-config.git" \
  "nix-config" \
  "${NIX_CONFIG_DOCS_DIR:-}" \
  "$HOME/nix-config/docs" \
  "$HOME/Projects/nix-config/docs" \
  "$ROOT_DIR/../nix-config/docs"

sync_repo \
  "flake-templates" \
  "https://github.com/SYKwong/flake-templates.git" \
  "templates" \
  "${FLAKE_TEMPLATES_DOCS_DIR:-}" \
  "$HOME/Projects/flake-templates/docs" \
  "$HOME/Templates/flake-templates/docs" \
  "$HOME/flake-templates/docs" \
  "$ROOT_DIR/../flake-templates/docs"
