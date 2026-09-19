## ACT Workflow

ACT workflow storage for new Specs is configured in `.act/config.yaml`.

ACT workflow semantics, Workflow Storage selection, artifact vocabulary, and domain-doc guidance are defined in `.act/workflow.md`.

## Multi-Package & Monorepo Rules
- **Sub-package Directory Commands**: Always run analysis and tests in the specific sub-package directory (e.g. `workdir: strata_core` using `dart analyze` and `dart test`).
- **Dependency Boundaries**: Sub-packages must adhere strictly to their defined boundaries. For example, `strata_core` must never import Flutter or third-party UI/network packages.
- **Boundary Verification**: Run package boundary audit tests (`package_dependency_test.dart`) whenever modifying package dependencies or imports.
- **Domain Conventions**: Refer to `GLOSSARY.md` for canonical naming (`ApiState`, `SensitiveStorageInterface`, `*Interface` suffix rule).
