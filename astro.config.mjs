// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import mermaid from 'astro-mermaid';
import starlightSidebarTopics from 'starlight-sidebar-topics';

// https://astro.build/config
export default defineConfig({
  site: 'https://nix.kyle-kwong.com',
  integrations: [
    mermaid({
      autoTheme: true,
    }),
    starlight({
      title: 'Nix Docs',
      description: 'Unified documentation for nix-config and flake-templates',
      customCss: ['./src/styles/catppuccin.css', './src/styles/custom.css'],
      head: [
        {
          tag: 'script',
          content: `
            document.addEventListener('keydown', (event) => {
              if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return;
              if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
              const target = event.target;
              if (target instanceof HTMLElement && (target.isContentEditable || ['INPUT', 'TEXTAREA', 'SELECT'].includes(target.tagName))) return;
              if (document.querySelector('dialog[open], [role="dialog"][aria-modal="true"]')) return;
              const selection = window.getSelection();
              if (selection && selection.toString().length > 0) return;

              const path = window.location.pathname.replace(/\\/+$/, '') || '/';
              if (event.key === 'ArrowLeft') {
                const prev = document.querySelector('a[rel="prev"]');
                if (prev instanceof HTMLElement) {
                  prev.click();
                } else if (path === '/nix-config/installation') {
                  window.location.href = '/nix-config/';
                } else if (path === '/templates/ci') {
                  window.location.href = '/templates/';
                }
              } else if (event.key === 'ArrowRight') {
                const next = document.querySelector('a[rel="next"]');
                if (next instanceof HTMLElement) {
                  next.click();
                } else if (path === '/nix-config') {
                  window.location.href = '/nix-config/installation/';
                } else if (path === '/templates') {
                  window.location.href = '/templates/ci/';
                }
              }
            });
          `,
        },
      ],
      expressiveCode: {
        themes: ['catppuccin-mocha', 'catppuccin-latte'],
        styleOverrides: {
          borderRadius: '0.5rem',
          borderColor: 'var(--sl-color-hairline)',
          codeBackground: 'var(--sl-color-gray-6)',
          frames: {
            editorBackground: 'var(--sl-color-gray-6)',
            terminalBackground: 'var(--sl-color-gray-6)',
            editorActiveTabBackground: 'var(--sl-color-gray-6)',
            frameBoxShadowCssValue: 'none',
          },
        },
      },
      social: [
        {
          icon: 'gitlab',
          label: 'nix-config (GitLab)',
          href: 'https://gitlab.com/kylekwong/nix-config',
        },
        {
          icon: 'github',
          label: 'flake-templates (GitHub)',
          href: 'https://github.com/SYKwong/flake-templates',
        },
      ],
      plugins: [
        starlightSidebarTopics([
          {
            label: 'nix-config',
            link: '/nix-config/',
            icon: 'laptop',
            items: [
              {
                label: 'Getting Started',
                items: [
                  { label: 'Overview', slug: 'nix-config' },
                  { label: 'System Installation', slug: 'nix-config/installation' },
                  { label: 'Adoption & Forking', slug: 'nix-config/adoption' },
                  { label: 'Post-Installation Setup', slug: 'nix-config/post-installation' },
                  { label: 'BIOS & Firmware', slug: 'nix-config/bios-update' },
                ],
              },
              {
                label: 'Architecture & Hosts',
                items: [
                  { label: 'Flake Architecture', slug: 'nix-config/architecture' },
                  { label: 'Split CI Architecture', slug: 'nix-config/split-ci' },
                  { label: 'Host Configurations', slug: 'nix-config/hosts' },
                  { label: 'Home Manager', slug: 'nix-config/home-manager' },
                  { label: 'Out-of-Store Dotfiles', slug: 'nix-config/dotfiles' },
                ],
              },
              {
                label: 'Modules & Extensibility',
                items: [
                  { label: 'System Modules', slug: 'nix-config/modules' },
                  { label: 'Sunshine Streaming & Tablet Display', slug: 'nix-config/sunshine' },
                  { label: 'Gaming & Gamescope', slug: 'nix-config/gaming' },
                  { label: 'Declarative Flatpak', slug: 'nix-config/flatpak' },
                  { label: 'Custom Shell Scripts', slug: 'nix-config/shell-scripts' },
                  { label: 'Nixpkgs Overlays', slug: 'nix-config/overlays' },
                ],
              },
              {
                label: 'Guides & Operations',
                items: [
                  { label: 'Secrets Management', slug: 'nix-config/secrets' },
                  { label: 'Managing Desktop Entries', slug: 'nix-config/desktop-entries' },
                  { label: 'Code Quality & Evaluation', slug: 'nix-config/code-quality' },
                ],
              },
            ],
          },
          {
            label: 'flake-templates',
            link: '/templates/',
            icon: 'document',
            items: [
              {
                label: 'General',
                items: [
                  { label: 'Overview', slug: 'templates' },
                  { label: 'CI & Automation', slug: 'templates/ci' },
                ],
              },
              {
                label: 'Language Templates',
                items: [
                  {
                    label: 'C',
                    items: [
                      { label: 'C (Clang)', slug: 'templates/c/clang' },
                      { label: 'C (GCC)', slug: 'templates/c/gcc' },
                    ],
                  },
                ],
              },
            ],
          },
        ]),
      ],
    }),
  ],
});
