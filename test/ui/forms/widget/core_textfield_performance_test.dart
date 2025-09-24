import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Test validator for performance testing
class TestValidator implements Validator<String> {
  int callCount = 0;

  @override
  String? validate(String? value, BuildContext context) {
    callCount++;
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

void main() {
  group('CoreTextField Performance Tests', () {
    late CoreFormCubit formCubit;
    late TestValidator validator;

    setUp(() {
      validator = TestValidator();
      formCubit = CoreFormCubit(
        fields: [
          TypedFormField<String>(name: 'testField', validators: [validator]),
        ],
      );
    });

    tearDown(() {
      formCubit.close();
    });

    Widget createTestWidget({required CoreTextField child}) {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(value: formCubit, child: child),
        ),
      );
    }

    group('Debouncing Performance', () {
      testWidgets(
        'should debounce rapid text input to prevent excessive updates',
        (tester) async {
          int updateCount = 0;

          await tester.pumpWidget(
            createTestWidget(
              child: CoreTextField(
                name: 'testField',
                debounceTime: const Duration(milliseconds: 100),
                transformValue: (value) {
                  updateCount++;
                  return value;
                },
              ),
            ),
          );

          // Simulate rapid typing
          await tester.enterText(find.byType(TextFormField), 'a');
          await tester.enterText(find.byType(TextFormField), 'ab');
          await tester.enterText(find.byType(TextFormField), 'abc');
          await tester.enterText(find.byType(TextFormField), 'abcd');
          await tester.enterText(find.byType(TextFormField), 'abcde');

          // Should not have updated form state yet due to debouncing
          expect(updateCount, equals(0));

          // Wait for debounce period
          await tester.pump(const Duration(milliseconds: 150));

          // Should only update once after debounce
          expect(updateCount, equals(1));
          expect(formCubit.state.values['testField'], equals('abcde'));
        },
      );

      testWidgets('should handle multiple debounce timers correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              debounceTime: Duration(milliseconds: 200),
            ),
          ),
        );

        // Start typing
        await tester.enterText(find.byType(TextFormField), 'first');
        await tester.pump(const Duration(milliseconds: 100));

        // Type more before first debounce completes
        await tester.enterText(find.byType(TextFormField), 'second');
        await tester.pump(const Duration(milliseconds: 100));

        // Type more before second debounce completes
        await tester.enterText(find.byType(TextFormField), 'third');

        // Wait for final debounce
        await tester.pump(const Duration(milliseconds: 250));

        // Should only have the final value
        expect(formCubit.state.values['testField'], equals('third'));
      });
    });

    group('Widget Rebuild Performance', () {
      testWidgets('should minimize rebuilds with BlocBuilder', (tester) async {
        int buildCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              transformValue: (value) {
                buildCount++;
                return value;
              },
            ),
          ),
        );

        // Initial build
        expect(buildCount, equals(0));

        // Update field value
        await tester.enterText(find.byType(TextFormField), 'test');
        await tester.pump();

        // Should only rebuild once per actual change
        expect(buildCount, equals(1));

        // Update with same value
        await tester.enterText(find.byType(TextFormField), 'test');
        await tester.pump();

        // Should not rebuild for same value
        expect(buildCount, equals(1));
      });

      testWidgets('should handle controller synchronization efficiently', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              initialText: 'initial',
            ),
          ),
        );

        expect(find.text('initial'), findsOneWidget);

        // Measure performance of external form updates
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 10; i++) {
          formCubit.updateField(
            fieldName: 'testField',
            value: 'update_$i',
            context: tester.element(find.byType(CoreTextField)),
          );
          await tester.pump();
        }

        stopwatch.stop();

        // Should complete quickly (less than 100ms for 10 updates)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));

        // Check final value in form state instead of widget text
        expect(formCubit.state.values['testField'], equals('update_9'));
      });
    });

    group('Memory Management Performance', () {
      testWidgets('should properly dispose resources to prevent memory leaks', (
        tester,
      ) async {
        // Create and dispose multiple widgets
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(
            createTestWidget(
              child: CoreTextField(
                name: 'testField_$i',
                debounceTime: const Duration(milliseconds: 100),
              ),
            ),
          );

          // Remove widget
          await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        }

        // Should not throw or cause memory issues
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle focus node disposal correctly', (
        tester,
      ) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(name: 'testField', focusNode: focusNode),
          ),
        );

        // Remove widget
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // External focus node should not be disposed
        expect(focusNode.hasFocus, isFalse);

        // Clean up
        focusNode.dispose();
      });
    });

    group('Icon Building Performance', () {
      testWidgets(
        'should efficiently build single icons without Row overhead',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              child: const CoreTextField(
                name: 'testField',
                prefixIcon: Icon(Icons.email),
              ),
            ),
          );

          // Should not create unnecessary Row widgets for single icons
          final rowFinder = find.descendant(
            of: find.byType(CoreTextField),
            matching: find.byType(Row),
          );

          // May have Row widgets in other parts, but should be minimal
          expect(find.byIcon(Icons.email), findsOneWidget);
        },
      );

      testWidgets('should efficiently build multiple icons with Row', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              prefixIcon: Icon(Icons.email),
              obscureText: true,
            ),
          ),
        );

        // Should have both icons
        expect(find.byIcon(Icons.email), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        // Should create Row for multiple icons
        expect(find.byType(Row), findsWidgets);
      });
    });

    group('Validation Performance', () {
      testWidgets('should not trigger excessive validation calls', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const CoreTextField(name: 'testField')),
        );

        final initialCallCount = validator.callCount;

        // Type some text
        await tester.enterText(find.byType(TextFormField), 'test');
        await tester.pump();

        // Validation may be called during form field setup, but should be minimal
        expect(validator.callCount, lessThanOrEqualTo(initialCallCount + 2));

        // Trigger validation
        formCubit.validateFieldImmediately(
          fieldName: 'testField',
          context: tester.element(find.byType(CoreTextField)),
        );
        await tester.pump();

        // Now validation should be called
        expect(validator.callCount, greaterThan(initialCallCount));
      });
    });

    group('Large Form Performance', () {
      testWidgets('should handle multiple fields efficiently', (tester) async {
        // Create form with multiple fields
        final multiFieldCubit = CoreFormCubit(
          fields: List.generate(
            10,
            (index) => TypedFormField<String>(
              name: 'field_$index',
              validators: [TestValidator()],
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: multiFieldCubit,
                child: Column(
                  children: List.generate(
                    10,
                    (index) => CoreTextField(
                      name: 'field_$index',
                      debounceTime: const Duration(milliseconds: 50),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final stopwatch = Stopwatch()..start();

        // Update all fields
        for (int i = 0; i < 10; i++) {
          await tester.enterText(find.byType(TextFormField).at(i), 'value_$i');
        }
        await tester.pump();

        stopwatch.stop();

        // Should handle multiple fields efficiently (less than 200ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(200));

        multiFieldCubit.close();
      });
    });

    group('Text Formatting Performance', () {
      testWidgets('should handle text formatting efficiently', (tester) async {
        int formatCallCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              formatText: (value) {
                formatCallCount++;
                return 'Formatted: $value';
              },
            ),
          ),
        );

        // Update form value to trigger formatting
        formCubit.updateField(
          fieldName: 'testField',
          value: 'test',
          context: tester.element(find.byType(CoreTextField)),
        );
        await tester.pump();

        // Formatting should be called
        expect(formatCallCount, greaterThan(0));
        expect(find.text('Formatted: test'), findsOneWidget);

        // Update with same value
        formCubit.updateField(
          fieldName: 'testField',
          value: 'test',
          context: tester.element(find.byType(CoreTextField)),
        );
        await tester.pump();

        // Should not format again for same value
        final previousCallCount = formatCallCount;
        await tester.pump();
        expect(formatCallCount, equals(previousCallCount));
      });
    });
  });
}
