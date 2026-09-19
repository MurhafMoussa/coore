---
type: Work Item
title: Create strata_navigation GoRouter wrapper package
parent: ../spec.md
---

## What to build
Implement `strata_navigation` sub-package containing GoRouter configuration wrappers, route guards, and `ScreenParams` abstractions.

## Required context
- Depends on `strata_core` and `go_router`.
- Provides GoRouter helper structures and route guards isolated from UI widgets and state management packages.

## Acceptance criteria
- [ ] `strata_navigation` sub-package is created.
- [ ] GoRouter config wrappers, route guards, and `ScreenParams` are defined.
- [ ] Unit tests for navigation guards and parameter passing pass.

## Covers
- User Stories: 1
- Requirements: 1, 2
- Testing Strategy: 1
- Interview Ledger: L9

## Blocked by
01-strata-core.md
