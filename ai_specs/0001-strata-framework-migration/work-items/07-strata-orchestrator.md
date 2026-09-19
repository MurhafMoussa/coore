---
type: Work Item
title: Create strata orchestrator meta-package and Dependency Injection framework
parent: ../spec.md
---

## What to build
Implement the `strata` orchestrator meta-package exporting all 6 sub-packages for single-line app initialization, package-specific GetIt registration extensions (`registerStrataNetwork()`, `registerStrataStorage()`, etc.), and `StrataInitializer.initialize()` / `StrataInitializer.reset()` with mandatory `await getIt.allReady()`.

## Required context
- `strata` meta-package depends on `strata_core`, `strata_network`, `strata_storage`, `strata_state`, `strata_navigation`, and `strata_ui`.
- `StrataInitializer.initialize()` invokes GetIt extension methods for sub-packages and MUST `await getIt.allReady()` before returning to prevent startup race conditions.
- `StrataInitializer.reset()` resets GetIt singletons for test teardowns.

## Acceptance criteria
- [ ] Meta-package `strata` is created exporting all sub-packages.
- [ ] Each sub-package exposes a GetIt registration extension method.
- [ ] `StrataInitializer.initialize()` awaits `getIt.allReady()` before returning.
- [ ] `StrataInitializer.reset()` cleans up GetIt singletons between test runs.
- [ ] Unit test verifies async initialization awaiting `allReady()` and clean reset behavior.
- [ ] Monorepo dependency audit test verifies sub-package dependency isolation.

## Covers
- User Stories: 1, 6
- Requirements: 1, 10, 11, 12
- Testing Strategy: 4, 5
- Technical Decisions: 1
- Interview Ledger: L7, L10

## Blocked by
01-strata-core.md
02-strata-storage.md
03-strata-network.md
04-strata-state.md
05-strata-navigation.md
06-strata-ui.md
