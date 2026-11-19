# nix-docs

[![Website](https://img.shields.io/badge/docs-nix.kyle--kwong.com-blue?style=flat-square)](https://nix.kyle-kwong.com)

Unified Astro Starlight documentation hub aggregating plain Markdown from `nix-config` and `flake-templates`.

📚 **Live Site:** [**nix.kyle-kwong.com**](https://nix.kyle-kwong.com)

---

## Content Sources

| Project               | Repository                                                              | Docs Path | Site Route     | Sync Trigger                           |
| :-------------------- | :---------------------------------------------------------------------- | :-------- | :------------- | :------------------------------------- |
| **`nix-config`**      | [`kylekwong/nix-config`](https://gitlab.com/kylekwong/nix-config)       | `docs/`   | `/nix-config/` | GitLab `notify-docs` + hourly cron     |
| **`flake-templates`** | [`SYKwong/flake-templates`](https://github.com/SYKwong/flake-templates) | `docs/`   | `/templates/`  | GitHub `notify-docs.yml` + hourly cron |

---

## Quick Start

```bash
npm install
npm run dev
```

All upstream documentation is committed directly under `src/content/docs/` so `npm run dev` and `npm run build` work standalone without network clones.

To pull the latest documentation from `nix-config` and `flake-templates`:

```bash
# Sync from local checkouts (~/nix-config/docs and ~/Templates/flake-templates/docs) when present:
npm run sync

# Force sync from upstream GitLab/GitHub remotes:
bash scripts/sync-docs.sh --remote
```

> [!NOTE]
> Files under `src/content/docs/` (except `src/content/docs/index.md`) are automatically synced and committed from [`kylekwong/nix-config`](https://gitlab.com/kylekwong/nix-config) and [`SYKwong/flake-templates`](https://github.com/SYKwong/flake-templates) via `.github/workflows/deploy.yml`. Edit documentation in its upstream source repository rather than directly in `src/content/docs/`.

---

## Formatting

Code and documentation authored in this repository are formatted with `treefmt-nix` (Prettier, `nixfmt`, `deadnix`, `statix`, `shfmt`, and `shellcheck`):

```bash
nix fmt
nix flake check
```

Upstream-synced directories (`src/content/docs/nix-config/` and `src/content/docs/templates/`) and `package-lock.json` are excluded because they are formatted in their respective source repositories. `flake.lock` and in-range npm dependencies (`package-lock.json`) are updated automatically every week via `.github/workflows/update-flake.yml` and `.github/workflows/update-npm.yml`.
