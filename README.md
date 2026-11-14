# nix-docs

[![Website](https://img.shields.io/badge/docs-nix.kyle--kwong.com-blue?style=flat-square)](https://nix.kyle-kwong.com)

Unified Astro Starlight documentation hub aggregating plain Markdown from `nix-config` and `flake-templates`.

📚 **Live Site:** [**nix.kyle-kwong.com**](https://nix.kyle-kwong.com)

---

## Content Sources

| Project | Repository | Docs Path | Site Route | Sync Trigger |
| :--- | :--- | :--- | :--- | :--- |
| **`nix-config`** | [`kylekwong/nix-config`](https://gitlab.com/kylekwong/nix-config) | `docs/` | `/nix-config/` | GitLab `notify-docs` + hourly cron |
| **`flake-templates`** | [`SYKwong/flake-templates`](https://github.com/SYKwong/flake-templates) | `docs/` | `/templates/` | GitHub `notify-docs.yml` + hourly cron |

---

## Quick Start

```bash
npm install
npm run dev
```

`scripts/sync-docs.sh` uses local checkouts (`~/nix-config/docs` and `~/Templates/flake-templates/docs`) when present outside CI, and shallow-clones from GitLab/GitHub in CI.
