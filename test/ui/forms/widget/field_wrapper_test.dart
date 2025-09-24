import 'package:coore/lib.dart';
import 'package:coore/src/ui/forms/widget/field_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Test validators for FieldWrapper testing
class TestStringValidator implements Validator<String> {
  @override
  String? validate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

class TestEmailValidator implements Validator<String> {
  @override
  String? validate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return null;
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}

class TestBoolValidator implements Validator<bool> {
  @override
  String? validate(bool? value, BuildContext context) {
    if (value != true) {
      return 'This field must be checked';
    }
    return null;
  }
}

class TestListValidator implements Validator<List<String>> {
  @override
  String? validate(List<String>? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Please select at least one item';
    }
    return null;
  }
}

class TestIntValidator implements Validator<int> {
  @override
  String? validate(int? value, BuildContext context) {
    if (value == null) {
      return 'This field is required';
    }
    return null;
  }
}

class TestMapValidator implements Validator<Map<String, dynamic>> {
  @override
  String? validate(Map<String, dynamic>? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

void main() {
  group('FieldWrapper', () {
    late CoreFormCubit formCubit;

    setUp(() {
      formCubit = CoreFormCubit(
        fields: [
          TypedFormField<String>(
            name: 'stringField',
            validators: [TestStringValidator(), TestEmailValidator()],
          ),
          TypedFormField<bool>(
            name: 'boolField',
            validators: [TestBoolValidator()],
          ),
          TypedFormField<List<String>>(
            name: 'listField',
            validators: [TestListValidator()],
          ),
          TypedFormField<int>(
            name: 'intField',
            validators: [TestIntValidator()],
          ),
          TypedFormField<Map<String, dynamic>>(
            name: 'mapField',
            validators: [TestMapValidator()],
          ),
        ],
      );
    });

    tearDown(() {
      formCubit.close();
    });

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(value: formCubit, child: child),
        ),
      );
    }

    group('Basic Functionality', () {
      testWidgets('should render with required parameters', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                return Text('Field: ${value ?? 'null'}');
              },
            ),
          ),
        );

        expect(find.byType(FieldWrapper<String>), findsOneWidget);
        expect(find.text('Field: null'), findsOneWidget);
      });

      testWidgets('should display initial value', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              initialValue: 'initial',
              builder: (context, value, error, hasError, updateValue) {
                return Text('Field: ${value ?? 'null'}');
              },
            ),
          ),
        );

        expect(find.text('Field: initial'), findsOneWidget);
      });

      testWidgets('should call builder with correct parameters', (
        tester,
      ) async {
        String? receivedValue;
        String? receivedError;
        bool? receivedHasError;
        void Function(String?)? receivedUpdateValue;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              initialValue: 'test',
              builder: (context, value, error, hasError, updateValue) {
                receivedValue = value;
                receivedError = error;
                receivedHasError = hasError;
                receivedUpdateValue = updateValue;
                return const Text('Test Widget');
              },
            ),
          ),
        );

        expect(receivedValue, equals('test'));
        expect(receivedError, isNull);
        expect(receivedHasError, isFalse);
        expect(receivedUpdateValue, isNotNull);
      });
    });

    group('Generic Type Support', () {
      testWidgets('should work with String type', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              initialValue: 'string value',
              builder: (context, value, error, hasError, updateValue) {
                return Text('String: $value');
              },
            ),
          ),
        );

        expect(find.text('String: string value'), findsOneWidget);
      });

      testWidgets('should work with bool type', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<bool>(
              fieldName: 'boolField',
              initialValue: true,
              builder: (context, value, error, hasError, updateValue) {
                return Text('Bool: $value');
              },
            ),
          ),
        );

        expect(find.text('Bool: true'), findsOneWidget);
      });

      testWidgets('should work with List type', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<List<String>>(
              fieldName: 'listField',
              initialValue: const ['item1', 'item2'],
              builder: (context, value, error, hasError, updateValue) {
                return Text('List: ${value?.join(', ') ?? 'empty'}');
              },
            ),
          ),
        );

        expect(find.text('List: item1, item2'), findsOneWidget);
      });

      testWidgets('should work with int type', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<int>(
              fieldName: 'intField',
              initialValue: 42,
              builder: (context, value, error, hasError, updateValue) {
                return Text('Int: $value');
              },
            ),
          ),
        );

        expect(find.text('Int: 42'), findsOneWidget);
      });

      testWidgets('should work with Map type', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<Map<String, dynamic>>(
              fieldName: 'mapField',
              initialValue: const {'key': 'value'},
              builder: (context, value, error, hasError, updateValue) {
                return Text('Map: ${value?['key'] ?? 'empty'}');
              },
            ),
          ),
        );

        expect(find.text('Map: value'), findsOneWidget);
      });
    });

    group('Value Updates', () {
      testWidgets('should update local value when updateValue is called', (
        tester,
      ) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return Text('Value: ${value ?? 'null'}');
              },
            ),
          ),
        );

        expect(find.text('Value: null'), findsOneWidget);

        // Update the value
        updateFunction?.call('updated');
        await tester.pump();

        expect(find.text('Value: updated'), findsOneWidget);
      });

      testWidgets('should update form state when value changes', (
        tester,
      ) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        // Update the value
        updateFunction?.call('form value');
        await tester.pump();

        // Check form state
        expect(formCubit.state.values['stringField'], equals('form value'));
      });

      testWidgets('should sync with external form updates', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                return Text('Value: ${value ?? 'null'}');
              },
            ),
          ),
        );

        expect(find.text('Value: null'), findsOneWidget);

        // Update form externally
        formCubit.updateField(
          fieldName: 'stringField',
          value: 'external update',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        await tester.pump();

        expect(find.text('Value: external update'), findsOneWidget);
      });
    });

    group('Debouncing', () {
      testWidgets('should debounce form updates', (tester) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              debounceTime: const Duration(milliseconds: 100),
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return Text('Value: ${value ?? 'null'}');
              },
            ),
          ),
        );

        // Rapid updates
        updateFunction?.call('a');
        updateFunction?.call('ab');
        updateFunction?.call('abc');

        // Local value should update immediately
        await tester.pump();
        expect(find.text('Value: abc'), findsOneWidget);

        // Form state should not be updated yet
        expect(formCubit.state.values['stringField'], isNull);

        // Wait for debounce
        await tester.pump(const Duration(milliseconds: 150));

        // Now form state should be updated
        expect(formCubit.state.values['stringField'], equals('abc'));
      });

      testWidgets('should cancel previous debounce timer', (tester) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              debounceTime: const Duration(milliseconds: 200),
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        // First update
        updateFunction?.call('first');
        await tester.pump(const Duration(milliseconds: 100));

        // Second update before first debounce completes
        updateFunction?.call('second');
        await tester.pump(const Duration(milliseconds: 250));

        // Should only have the second value
        expect(formCubit.state.values['stringField'], equals('second'));
      });
    });

    group('Value Transformation', () {
      testWidgets('should transform values before updating form', (
        tester,
      ) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              transformValue: (value) => value.toUpperCase(),
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        updateFunction?.call('lowercase');
        await tester.pump();

        expect(formCubit.state.values['stringField'], equals('LOWERCASE'));
      });

      testWidgets('should not transform null values', (tester) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              transformValue: (value) => value.toUpperCase(),
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        updateFunction?.call(null);
        await tester.pump();

        expect(formCubit.state.values['stringField'], isNull);
      });

      testWidgets('should work with complex transformations', (tester) async {
        void Function(List<String>?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<List<String>>(
              fieldName: 'listField',
              transformValue: (value) =>
                  value.map((e) => e.toUpperCase()).toList(),
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        updateFunction?.call(['hello', 'world']);
        await tester.pump();

        expect(formCubit.state.values['listField'], equals(['HELLO', 'WORLD']));
      });
    });

    group('Callbacks', () {
      testWidgets('should call onValueChanged callback', (tester) async {
        String? changedValue;
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              onValueChanged: (value) => changedValue = value,
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        updateFunction?.call('callback test');
        await tester.pump();

        expect(changedValue, equals('callback test'));
      });

      testWidgets('should call onValueChanged before debouncing', (
        tester,
      ) async {
        String? changedValue;
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              debounceTime: const Duration(milliseconds: 100),
              onValueChanged: (value) => changedValue = value,
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        updateFunction?.call('immediate');

        // Callback should be called immediately
        expect(changedValue, equals('immediate'));

        // Form state should not be updated yet
        expect(formCubit.state.values['stringField'], isNull);
      });
    });

    group('Error Handling', () {
      testWidgets('should display error when field has validation error', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                return Column(
                  children: [
                    Text('Value: ${value ?? 'null'}'),
                    if (hasError) Text('Error: $error'),
                  ],
                );
              },
            ),
          ),
        );

        // Trigger validation with invalid value
        formCubit.updateField(
          fieldName: 'stringField',
          value: 'invalid-email',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        formCubit.validateFieldImmediately(
          fieldName: 'stringField',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        await tester.pump();

        expect(
          find.text('Error: Please enter a valid email address'),
          findsOneWidget,
        );
      });

      testWidgets('should not show error when field is valid', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                return Column(
                  children: [
                    Text('Value: ${value ?? 'null'}'),
                    Text('HasError: $hasError'),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('HasError: false'), findsOneWidget);
      });
    });

    group('Initial Value Handling', () {
      testWidgets('should update form state with initial value', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              initialValue: 'initial form value',
              builder: (context, value, error, hasError, updateValue) {
                return Text('Value: $value');
              },
            ),
          ),
        );

        // Wait for post frame callback
        await tester.pump();

        expect(
          formCubit.state.values['stringField'],
          equals('initial form value'),
        );
      });

      testWidgets('should not update form state when initial value is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                return Text('Value: ${value ?? 'null'}');
              },
            ),
          ),
        );

        await tester.pump();

        expect(formCubit.state.values['stringField'], isNull);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('should dispose debounce timer on dispose', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              debounceTime: const Duration(milliseconds: 100),
              builder: (context, value, error, hasError, updateValue) {
                return const Text('Test');
              },
            ),
          ),
        );

        // Remove widget
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Should not throw any exceptions
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle widget rebuild correctly', (tester) async {
        bool showWidget = true;

        await tester.pumpWidget(
          createTestWidget(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    if (showWidget)
                      FieldWrapper<String>(
                        fieldName: 'stringField',
                        initialValue: 'test',
                        builder:
                            (context, value, error, hasError, updateValue) {
                              return Text('Value: $value');
                            },
                      ),
                    ElevatedButton(
                      onPressed: () => setState(() => showWidget = !showWidget),
                      child: const Text('Toggle'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('Value: test'), findsOneWidget);

        // Toggle widget off
        await tester.tap(find.text('Toggle'));
        await tester.pump();

        expect(find.text('Value: test'), findsNothing);

        // Toggle widget back on
        await tester.tap(find.text('Toggle'));
        await tester.pump();

        expect(find.text('Value: test'), findsOneWidget);
      });
    });

    group('Form State Priority', () {
      testWidgets('should prioritize form value over local value', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              initialValue: 'local',
              builder: (context, value, error, hasError, updateValue) {
                return Text('Value: $value');
              },
            ),
          ),
        );

        // Initially shows local value
        expect(find.text('Value: local'), findsOneWidget);

        // Update form state externally
        formCubit.updateField(
          fieldName: 'stringField',
          value: 'form',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        await tester.pump();

        // Should now show form value
        expect(find.text('Value: form'), findsOneWidget);
      });

      testWidgets('should fall back to local value when form value is null', (
        tester,
      ) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return Text('Value: ${value ?? 'null'}');
              },
            ),
          ),
        );

        // Update local value
        updateFunction?.call('local only');
        await tester.pump();

        expect(find.text('Value: local only'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid dispose during debounce', (
        tester,
      ) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              debounceTime: const Duration(milliseconds: 100),
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        // Start debounce
        updateFunction?.call('test');

        // Dispose widget before debounce completes
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Wait for what would have been debounce time
        await tester.pump(const Duration(milliseconds: 150));

        // Should not throw
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle null field name gracefully', (tester) async {
        // This should be caught at compile time, but test runtime behavior
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: '',
              builder: (context, value, error, hasError, updateValue) {
                return const Text('Empty field name');
              },
            ),
          ),
        );

        expect(find.text('Empty field name'), findsOneWidget);
      });
    });

    group('Coverage Edge Cases', () {
      testWidgets('should handle transformation with null check', (
        tester,
      ) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              transformValue: (value) => value.toUpperCase(),
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return const Text('Test');
              },
            ),
          ),
        );

        // Test with null value (should not call transform)
        updateFunction?.call(null);
        await tester.pump();

        expect(formCubit.state.values['stringField'], isNull);

        // Test with non-null value (should call transform)
        updateFunction?.call('test');
        await tester.pump();

        expect(formCubit.state.values['stringField'], equals('TEST'));
      });

      testWidgets('should handle ValueTester.isBlank for error checking', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                return Text('HasError: $hasError');
              },
            ),
          ),
        );

        // Initially no error
        expect(find.text('HasError: false'), findsOneWidget);

        // Set error in form state
        formCubit.updateField(
          fieldName: 'stringField',
          value: 'invalid-email',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        formCubit.validateFieldImmediately(
          fieldName: 'stringField',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        await tester.pump();

        // Should now have error
        expect(find.text('HasError: true'), findsOneWidget);
      });

      testWidgets('should handle form value casting correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              builder: (context, value, error, hasError, updateValue) {
                return Text('Value: ${value ?? 'null'}');
              },
            ),
          ),
        );

        // Set form value externally
        formCubit.updateField(
          fieldName: 'stringField',
          value: 'form value',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        await tester.pump();

        expect(find.text('Value: form value'), findsOneWidget);
      });

      testWidgets('should handle effective value priority logic', (
        tester,
      ) async {
        void Function(String?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<String>(
              fieldName: 'stringField',
              initialValue: 'initial',
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return Text('Value: ${value ?? 'null'}');
              },
            ),
          ),
        );

        // Should show initial value
        expect(find.text('Value: initial'), findsOneWidget);

        // Update local value
        updateFunction?.call('local');
        await tester.pump();

        // Should show form value (which gets updated)
        expect(find.text('Value: local'), findsOneWidget);

        // Clear form value
        formCubit.updateField(
          fieldName: 'stringField',
          context: tester.element(find.byType(FieldWrapper<String>)),
        );
        await tester.pump();

        // Should fall back to local value
        expect(find.text('Value: local'), findsOneWidget);
      });
    });

    group('Complex Scenarios', () {
      testWidgets('should handle multiple field wrappers independently', (
        tester,
      ) async {
        void Function(String?)? updateFunction1;
        void Function(String?)? updateFunction2;

        await tester.pumpWidget(
          createTestWidget(
            child: Column(
              children: [
                FieldWrapper<String>(
                  fieldName: 'stringField',
                  builder: (context, value, error, hasError, updateValue) {
                    updateFunction1 = updateValue;
                    return Text('Field1: ${value ?? 'null'}');
                  },
                ),
                FieldWrapper<String>(
                  fieldName: 'stringField', // Same field name
                  builder: (context, value, error, hasError, updateValue) {
                    updateFunction2 = updateValue;
                    return Text('Field2: ${value ?? 'null'}');
                  },
                ),
              ],
            ),
          ),
        );

        // Update first field
        updateFunction1?.call('value1');
        await tester.pump();

        // Both should show the same value (shared form state)
        expect(find.text('Field1: value1'), findsOneWidget);
        expect(find.text('Field2: value1'), findsOneWidget);

        // Update second field
        updateFunction2?.call('value2');
        await tester.pump();

        // Both should show the new value
        expect(find.text('Field1: value2'), findsOneWidget);
        expect(find.text('Field2: value2'), findsOneWidget);
      });

      testWidgets('should work with custom widget implementations', (
        tester,
      ) async {
        void Function(List<String>?)? updateFunction;

        await tester.pumpWidget(
          createTestWidget(
            child: FieldWrapper<List<String>>(
              fieldName: 'listField',
              initialValue: const ['item1'],
              builder: (context, value, error, hasError, updateValue) {
                updateFunction = updateValue;
                return Column(
                  children: [
                    ...?value?.map((item) => Text('Item: $item')),
                    ElevatedButton(
                      onPressed: () {
                        final newList = List<String>.from(value ?? []);
                        newList.add('new item');
                        updateValue(newList);
                      },
                      child: const Text('Add Item'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('Item: item1'), findsOneWidget);

        // Add item through custom widget
        await tester.tap(find.text('Add Item'));
        await tester.pump();

        expect(find.text('Item: item1'), findsOneWidget);
        expect(find.text('Item: new item'), findsOneWidget);
      });
    });
  });
}
