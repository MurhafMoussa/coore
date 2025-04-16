# Coding policy for flutter projects

### **I. Architectural Principles**

1\.  **Encapsulate Business Logic in Domain Entities**

    *All domain-specific rules and operations must be contained within entities.*
```
    // ❌ Non-compliant: Logic in UI

    if (cart.totalPrice > 100) showDiscountBanner();

    // ✅ Compliant: Logic in entity

    class ShoppingCartEntity extends Identifiable {

      bool get isEligibleForDiscount => totalPrice > 100;

    }
```

2\.  **Adhere to Clean Architecture Layers**

    *Separate code into distinct layers (domain, data, presentation).*

    lib/

    ├─ domain/  # Entities, Use Cases

    ├─ data/    # Repositories, Data Sources

    └─ presentation/  # UI, State Management

* * * * *

### **II. Code Structure & Design**

1\.  **Prioritize Composition Over Inheritance**

    *Use dependency injection and mixins instead of class hierarchies.*

``` 
    // ❌ Inheritance

    class AndroidButton extends Button {}

    // ✅ Composition

    class CustomButton {

      final ButtonStyle style;

      CustomButton(this.style);

    }
```

2\.  **Leverage Core Dependencies**

    *Standardize on approved packages (e.g., `dio` for HTTP, `flutter_bloc` for state).*

3\.  **Implement Code Generation**

    *Use tools like `freezed` for boilerplate reduction.*

```dev_dependencies:

  build_runner: ^2.3.3

  freezed: ^2.0.0
```

1\.  **Use Configuration Objects**

    *Replace boolean parameters with structured objects.*

```
// ❌

fetchData(true, false);

// ✅

fetchData(options: RequestOptions(useCache: true, retry: false));
```
* * * * *

### **III. Code Quality & Readability**

1\.  **Enforce Linting Standards**

    *Define rules in `analysis_options.yaml`.*

``` 
    linter:

      rules:

        - avoid_print

        - prefer_const_constructors

```

2\.  **Adopt Structured Logging**

    *Replace `print()` with a centralized logger.*
```
    // ❌

    print('Error: $error');

    // ✅

    getIt<AppLogger>().error('API Failure', error: error, stackTrace: stackTrace);
```

3\.  **Apply Semantic Naming**

    *Use concise, descriptive identifiers.*

```
     // ❌

    class Mgr {}

    void p() {}

    // ✅

    class PaymentManager {}

    void processTransaction() {}
```

4\.  **Simplify Control Flow**

    *Prefer guard clauses over nested conditionals.*

``` 
    // ❌ Nested

    if (user != null) {

      if (user.isActive) { /* ... */ }

    }

    // ✅ Guard

    if (user == null || !user.isActive) return;
```

* * * * *

### **IV. State Management**

1\.  **Enforce Immutability**

    *Mark state classes as `@immutable` or use freezed classes.*

```
@immutable

class AppState {

  final List<Product> items;

  const AppState(this.items);

}
```

1\.  **Restrict `setState` Usage**

    *Limit to simple UI components (<50 LOC).*

```
// Allowed only for trivial state

class _ToggleButton extends StatefulWidget {

  @override

  _ToggleButtonState createState() => _ToggleButtonState();

}
```

* * * * *

### **V. Configuration & Environment**

1\.  **Standardize Environment Variables**

    *Store configurations in `.env` files.*

```
/PROJECT_DIRECTORY/

  .env.development

  .env.production

// Access via EnvironmentConfig class
final environment=CoreEnvironment.getEnvironmentFromString(String.fromEnvironment('ENVIRONMENT'));
await EnvironmentConfig.loadEnv(environment)
final apiKey = EnvironmentConfig.getString('API_KEY');
```
--------------------------------------------------------------------------------
# GitLab Policy for Branch Naming, Commit Conventions, Versioning, and Changelog

This document establishes guidelines for managing branches, commit messages, versioning, and changelog maintenance in our Flutter application hosted on GitLab.

---

## 1. Branch Naming and Structure

Our GitLab repository follows a structured branching model with three core branches:

- **`development`**: Contains the latest ongoing development and new features.
- **`staging`**: Used for integration testing and pre-production validation.
- **`production`**: Contains production-ready code that is deployed to end users.

### Releases Folder Structure

We organize releases inside a `releases` folder, where each release has its own subfolder. The structure follows:

```
/releases
    /<release-version>/
        - development
        - staging
        - production
```

For example, release `v1.2.0` will have:
```
/releases/v1.2.0/
    - development
    - staging
    - production
```

For each branch it will be named following this naming convention:

```
/releases/<release-version>/<ticket-id>

```
For example, in the version 4 and ticket 55 

```
/releases/v4.0.0/55

```
Feature and bugfix branches can be created from `development` and merged back via merge requests.

Hotfix branches are created from `production`, merged into `staging` and `development`, and then deployed.

---

## 2. Commit Message Conventions

We follow a structured commit message format to maintain clarity:

### Format:
```
<type>(<scope>): <message>

```

### Types:
- **feat**: Introduces a new feature or functionality.
- **fix**: Patches a bug or resolves an issue.
- **docs**: Updates or improves documentation.
- **style**: Changes that do not affect the meaning of the code (e.g., formatting, white-space, punctuation).
- **refactor**: Code changes that neither add a feature nor fix a bug, but improve the code structure.
- **perf**: Introduces performance improvements.
- **test**: Adds missing tests or corrects existing tests.
- **chore**: Maintenance tasks or changes to the build process and auxiliary tools.
- **revert**: Reverts a previous commit.
- **translation**: Updates or adds new translations for localization.

### Example Commits:
```
feat(auth): add Google login
fix(ui): resolve layout shift in checkout page
refactor(database): optimize query performance
```

---

## 3. Versioning Policy

We follow **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: Backward-compatible new features
- **PATCH**: Backward-compatible bug fixes

Examples:
- `1.0.0` → Initial release
- `1.1.0` → New feature added
- `1.1.1` → Bug fix applied

Every new release must be tagged in GitLab (`git tag v1.2.0`).

---

## 4. Changelog Management

We maintain a `CHANGELOG.md` file in the repository root.

### Changelog Format:
```
## [Version] - YYYY-MM-DD
### Added
- New feature descriptions
### Fixed
- Bug fixes
### Changed
- Updates to existing features
```

Example:
```
## [1.2.0] - 2025-04-02
### Added
- Implemented dark mode
- Added user profile section
### Fixed 
- Resolved payment gateway timeout issue
```
---

## 5. Merge Request (MR) Guidelines

- All branches must be merged via **merge requests**.
- Each MR should include:
  - A clear description
  - At least one approval before merging
- No direct commits to `staging`,`production` or `development`.

---

## 6. Deployment Strategy

- `development` is continuously deployed to the dev environment.
- `staging` is deployed for testing before release.
- `production` is deployed only after successful staging tests.

---


This policy ensures consistency and clarity for all team members working on the Flutter application.

