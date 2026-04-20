# Re-origin from nickjj/dotfiles without upstream tooling

## Status

Accepted — 2026-04-20

## Context

This repo started as a copy of `nickjj/dotfiles`. nickjj's install and bootstrap scripts ship a sync-with-upstream workflow: `bootstrap` auto-adds an `upstream` git remote pointing at `DOTFILES_UPSTREAM_URL` (default `nickjj/dotfiles`), and `./install --diff` compares local files to that remote so the user can cherry-pick updates. We considered three options for the relationship post-re-origin:

- **A. Keep the upstream remote + `--diff` untouched.** Cheap. Weakens the "standalone identity" story — the repo still acts like a fork.
- **B. Drop the upstream remote and `--diff` entirely.** Strip the `remote add upstream` logic from `bootstrap`, remove `DOTFILES_UPSTREAM_URL`, remove the `--diff` code path. Ad-hoc `git fetch` replaces the curation ritual.
- **C. Keep the mechanics but rename `upstream` → `nickjj`.** Hybrid. Same tooling, honest name.

## Decision

**B.** We drop all upstream tooling. nickjj is credited in LICENSE (dual copyright) and in a single README line. Full git history is preserved so `git blame` and archaeology still work. There is no git remote, no env var, and no `./install --diff` referencing nickjj.

## Why

We plan to diverge substantially (new tools, new font, new package curation) and to magpie ideas from multiple sources — `omarchy`, `ivn-term`, and others. Privileging nickjj with a permanent git remote while treating other sources as ad-hoc would be arbitrary. Cleanest: treat every source the same way — manual `git fetch` when we want to look, no baked-in coupling.

## Consequences

- `bootstrap` no longer sets up an `upstream` remote or writes `DOTFILES_UPSTREAM_URL` to shell rc files.
- `install` loses its `--diff` flag and the associated comparison code.
- Pulling a specific change from `nickjj/dotfiles` later requires three manual git commands, not one flag. This is a deliberate cost.
- A future reader unfamiliar with the context will see the git history start in someone else's name but find no `upstream` remote to explain the relationship. This ADR is that explanation.
