---
type: Work Item
title: Create strata_navigation GoRouter wrapper package and NavigationServiceInterface contract
parent: ../spec.md
---

## What to build
Define pure Dart router-agnostic `NavigationServiceInterface` in `strata_core` and implement the `strata_navigation` sub-package providing default GoRouter implementation (`GoRouterNavigationService`, `CoreRouter`), route guards, and `ScreenParams` abstractions.

## Required context
- Pure contract `NavigationServiceInterface` in `strata_core` allows consumer applications or alternative routing packages (e.g. AutoRoute) to swap navigation engines seamlessly without changing BLoC/Service code.
- `strata_navigation` depends on `strata_core`, `flutter`, and `go_router`.
- Provides GoRouter helper structures, route guards, and default `GoRouterNavigationService` isolated from UI widgets and state management packages.

## Acceptance criteria
- [x] `NavigationServiceInterface` contract defined in `strata_core` with zero GoRouter or Flutter dependencies.
- [x] `strata_navigation` sub-package is created.
- [x] `GoRouterNavigationService` implementing `NavigationServiceInterface` is provided.
- [x] GoRouter config wrappers (`CoreRouter`, `NavigationConfigEntity`), route guards (`RouteGuardInterface`), and `ScreenParams` are defined.
- [x] DI extension `registerStrataNavigation()` is implemented.
- [x] Unit tests for navigation service, route guards, and parameter passing pass.
- [x] Package dependency audit test verifies `strata_navigation` boundaries.

## Covers
- User Stories: 1
- Requirements: 1, 2
- Testing Strategy: 1
- Interview Ledger: L9

## Blocked by
01-strata-core.md
