# Rename omarchy/bin scripts to `dot-*` on import, not keep `omarchy-*`

## Status

Accepted — 2026-04-22

## Context

Phase 2a imports scripts from `omarchy/bin` (tracked in PRD-0003 and issue #36). `omarchy/bin` ships 214 scripts, each named `omarchy-<category>-<action>`. 126 of 214 reference other `omarchy-*` scripts internally, so cross-references form a dense graph.

Three naming options at import time:

- **A. Keep `omarchy-*` prefix.** Import verbatim under the original names, land in `.local/bin/` alongside the existing `dot-*` fleet. Two prefixes in one directory.
- **B. Rename to `dot-*`.** Strip the `omarchy-` prefix, prepend `dot-`. Consistent with the established repo convention (existing `.local/bin/dot-theme-set`, `dot-launch-or-focus`, etc.). Requires rewriting the 187 cross-references (126 scripts × average refs) so internal calls resolve.
- **C. Rename to a third prefix (`dot-om-*` or `ivn-*`).** Namespace separation, some origin signal preserved in the name.

The choice has several knock-on effects:

- **Collisions with existing `dot-*` scripts.** Your `.local/bin/` already has `dot-launch-or-focus`, `dot-launch-or-focus-tui`, `dot-theme-set`, `dot-theme-set-bg`, `dot-menu`, `dot-screenshot` — niri-based implementations. Under option A these coexist under different prefixes. Under option B, every collision needs a per-case resolution.
- **Source attribution.** Option A leaves "omarchy" visible in every PATH invocation. Option B drops provenance from daily use; it survives only in LICENSE and optional per-file headers.
- **Consistency with ADR-0001.** ADR-0001 established a pattern for how this repo treats source material: nickjj gets a LICENSE credit and one README line, no git remote, no tooling coupling. Option A gives omarchy *more* visibility than nickjj currently gets. Option B matches the ADR-0001 pattern.

## Decision

**B.** Imported scripts are renamed `omarchy-*` → `dot-*`. Cross-references are rewritten in a mechanical sed sweep at import. Provenance is preserved via per-file header comment (`# lifted from omarchy/bin/<original-name>`) plus existing LICENSE credit. No `omarchy-*` prefix lands in `.local/bin/`.

## Why

Three reasons:

1. **Consistency with repo convention.** `.local/bin/` already uses `dot-*`. Adding a second prefix fragments the namespace for a cosmetic "origin in name" benefit.
2. **Consistency with ADR-0001.** Omarchy is one of several reference sources (nickjj, ivn-term, omarchy — per CONTEXT.md "Relationships"). ADR-0001 decided not to privilege any source with permanent tooling or naming footprint. Prefixing 119 imported scripts with `omarchy-` would privilege omarchy in a way ADR-0001 specifically rejected for nickjj.
3. **Rename doubles as a dependency-closure audit.** After the rename, any unresolved `omarchy-*` call inside an imported script is either (a) a cross-ref we forgot to rewrite, or (b) a script we thought we could import but actually depends on a skipped/deferred one. Either is a bug the rename surfaces. Keeping the prefix hides this by making internal calls work even when deps are missing.

The main counter-argument for option A was mechanical cost: rewriting 187 cross-refs across 126 scripts. That cost is real but is a one-time sed sweep, not ongoing. Option A trades one-time mechanical cost for permanent namespace fragmentation; option B trades permanent fragmentation for one-time mechanical cost. Prefer the one-time cost.

Option C was rejected as a worse version of B: same cross-ref rewrite cost, still three prefixes in the directory, no real win over either A or B.

## Consequences

- Every imported script carries a `# lifted from omarchy/bin/<name>` header. Provenance is legible at the file level, not the invocation level.
- Phase 2b (Hyprland) imports the deferred set under the same rule. When `omarchy-launch-or-focus` becomes `dot-launch-or-focus` and the niri-native `dot-launch-or-focus` already exists, Phase 2b needs a runtime dispatch — either based on active compositor or by retiring one implementation. Not a 2a concern; flagged in PRD-0003 as a 2b design point.
- A future reader who runs `file ~/.local/bin/dot-font-set` sees a plain script with no indication it was lifted from omarchy. The header comment inside the file explains. This ADR is the broader explanation.
- Re-sync from omarchy after upstream changes is a translation step, not a diff. See PRD-0003 "Re-triage workflow".
- Dropping the `omarchy-` prefix makes it cheap to later source-graft from a different project — if some hypothetical future `some-other-distro/bin/` has useful utilities, the same `dot-*` rename pattern applies. No prefix proliferation.
