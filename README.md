# Nix Docs

Unified Astro Starlight documentation site pulling plain Markdown from:

- [`kylekwong/nix-config`](https://gitlab.com/kylekwong/nix-config) (`docs/src/content/docs/`)
- [`SYKwong/flake-templates`](https://github.com/SYKwong/flake-templates) (`docs/`)

## Local Development

```bash
npm install
npm run dev
```

`scripts/sync-docs.sh` uses local checkouts (`~/nix-config` and `~/Templates/flake-templates`) when present outside CI, and shallow-clones from GitLab/GitHub in CI.
