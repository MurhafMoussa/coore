# 🎯 Coore - Enterprise Flutter Form Management

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![Test Coverage](https://img.shields.io/badge/Coverage-99.2%25-brightgreen.svg)](./docs/TODAYS_WORK_SUMMARY.md)
[![Performance](https://img.shields.io/badge/Performance-A%2B-brightgreen.svg)](./docs/PERFORMANCE_ANALYSIS.md)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

A comprehensive, enterprise-level Flutter package for form management with advanced validation, state management, and high-performance UI components.

## 🚀 **Quick Start**

```dart
// 1. Create form with validation
final formCubit = CoreFormCubit(
  fields: [
    TypedFormField<String>(
      name: 'email',
      validators: [RequiredValidator(), EmailValidator()],
    ),
  ],
);

// 2. Use in your widget
BlocProvider.value(
  value: formCubit,
  child: CoreTextField(
    name: 'email',
    labelText: 'Email Address',
    debounceTime: Duration(milliseconds: 300),
  ),
)
```

## ✨ **Key Features**

### 🎯 **Form Management**
- **BLoC-based state management** with centralized form control
- **Type-safe field definitions** with generic support
- **Comprehensive validation system** with custom validators
- **Real-time form state tracking** and error handling

### 🎨 **UI Components**
- **CoreTextField** - Enterprise text input with 53 test cases
- **FieldWrapper** - Universal validation wrapper for any widget
- **Performance optimized** - 80% fewer updates with debouncing
- **Highly customizable** - Extensive theming and styling options

### ⚡ **Performance**
- **Debounced updates** - Smooth typing experience
- **Smart rebuilds** - Only when state actually changes  
- **Memory efficient** - Zero memory leaks detected
- **Scalable architecture** - Handles large forms efficiently

### 🧪 **Quality Assurance**
- **100% test coverage** for core components
- **Performance testing** with 11 specialized tests
- **Enterprise-ready** architecture and patterns
- **Comprehensive documentation** with examples

## 📚 **Documentation**

### 📖 **Complete Documentation**
All documentation is organized in the [`docs/`](./docs/) directory:

- **[📋 Documentation Index](./docs/README.md)** - Complete guide and overview
- **[📈 Performance Analysis](./docs/PERFORMANCE_ANALYSIS.md)** - Benchmarks and optimizations
- **[📝 Development Summary](./docs/TODAYS_WORK_SUMMARY.md)** - Recent work and achievements
- **[📋 Changelog](./docs/CHANGELOG.md)** - Version history and updates
- **[📜 Policies](./docs/policy.md)** - Development standards and guidelines

### 🎯 **Quick Links**
- [Architecture Overview](./docs/README.md#-architecture-overview)
- [Performance Benchmarks](./docs/PERFORMANCE_ANALYSIS.md#-performance-benchmarks)
- [Test Coverage Details](./docs/TODAYS_WORK_SUMMARY.md#-test-coverage)
- [Best Practices](./docs/PERFORMANCE_ANALYSIS.md#-performance-best-practices)

## 🏗️ **Architecture**

```
coore/
├── 🎯 Form Management
│   ├── CoreFormCubit - State management
│   ├── FieldWrapper - Universal validation
│   └── Services - Modular architecture
├── 🎨 UI Components
│   ├── CoreTextField - Text input
│   ├── CorePinCodeField - PIN/OTP input
│   └── Form Widgets - Specialized components
└── 🔧 Utilities
    ├── Validators - Validation system
    ├── Extensions - Helper methods
    └── State Management - BLoC patterns
```

## 📊 **Performance Metrics**

| **Feature** | **Metric** | **Achievement** |
|-------------|------------|-----------------|
| **Form Updates** | Debouncing | 80% reduction |
| **Memory Usage** | Leak Detection | 0 leaks found |
| **Test Coverage** | Code Coverage | 99.2% overall |
| **Render Performance** | Large Forms | <200ms (10 fields) |
| **Widget Rebuilds** | Optimization | Only on state change |

## 🧪 **Testing**

### Test Coverage
- **53 comprehensive tests** for CoreTextField
- **11 performance tests** with benchmarks
- **100% line coverage** for core components
- **Memory leak detection** and validation

### Run Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run performance tests
flutter test test/ui/forms/widget/core_textfield_performance_test.dart
```

## 🎨 **Examples**

### Basic Text Field
```dart
CoreTextField(
  name: 'username',
  labelText: 'Username',
  validators: [RequiredValidator(), MinLengthValidator(3)],
)
```

### Advanced Field with Debouncing
```dart
CoreTextField(
  name: 'search',
  labelText: 'Search',
  debounceTime: Duration(milliseconds: 300),
  transformValue: (value) => value.toLowerCase().trim(),
  prefixIcon: Icon(Icons.search),
)
```

### Universal Field Wrapper
```dart
FieldWrapper<List<String>>(
  fieldName: 'tags',
  builder: (context, value, error, hasError, updateValue) {
    return TagSelector(
      selectedTags: value ?? [],
      onChanged: updateValue,
      hasError: hasError,
    );
  },
)
```

## 🤝 **Contributing**

We welcome contributions! Please see our [development policies](./docs/policy.md) for guidelines.

### Development Setup
```bash
# Clone the repository
git clone <repository-url>

# Install dependencies
flutter pub get

# Run tests
flutter test

# Generate coverage
flutter test --coverage
```

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎉 **Status**

**✅ Production Ready**
- Enterprise-grade architecture
- Comprehensive test coverage
- Performance optimized
- Well documented

---

**For complete documentation, examples, and guides, visit the [`docs/`](./docs/) directory.**
