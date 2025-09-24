import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple test validators
class TestRequiredValidator implements Validator<String> {
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

void main() {
  group('CoreTextField', () {
    late CoreFormCubit formCubit;

    setUp(() {
      formCubit = CoreFormCubit(
        fields: [
          TypedFormField<String>(
            name: 'testField',
            validators: [TestRequiredValidator()],
          ),
          TypedFormField<String>(
            name: 'emailField',
            validators: [TestRequiredValidator(), TestEmailValidator()],
          ),
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

    group('Constructor and Assertions', () {
      test(
        'should throw assertion error when expands is true with maxLines',
        () {
          expect(
            () => CoreTextField(name: 'test', expands: true, maxLines: 5),
            throwsAssertionError,
          );
        },
      );

      test(
        'should throw assertion error when expands is true with minLines',
        () {
          expect(
            () => CoreTextField(name: 'test', expands: true, minLines: 2),
            throwsAssertionError,
          );
        },
      );

      test(
        'should not throw when expands is true with null maxLines and minLines',
        () {
          expect(
            () => const CoreTextField(
              name: 'test',
              expands: true,
              maxLines: null,
            ),
            returnsNormally,
          );
        },
      );
    });

    group('Basic Rendering', () {
      testWidgets('should render with required name parameter', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const CoreTextField(name: 'testField')),
        );

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byType(CoreTextField), findsOneWidget);
      });

      testWidgets('should render with initial text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              initialText: 'Initial Value',
            ),
          ),
        );

        expect(find.text('Initial Value'), findsOneWidget);
      });

      testWidgets('should render with label text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              labelText: 'Test Label',
            ),
          ),
        );

        expect(find.text('Test Label'), findsOneWidget);
      });

      testWidgets('should render with hint text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              hintText: 'Test Hint',
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
      });
    });

    group('Required Star Indicator', () {
      testWidgets('should show required star when showRequiredStar is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              labelText: 'Test Label',
              showRequiredStar: true,
            ),
          ),
        );

        expect(find.text('*'), findsOneWidget);
      });

      testWidgets('should use custom required star widget', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              labelText: 'Test Label',
              showRequiredStar: true,
              requiredStarWidget: Icon(Icons.star),
            ),
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('should use custom required star color', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              labelText: 'Test Label',
              showRequiredStar: true,
              requiredStarColor: Colors.blue,
            ),
          ),
        );

        final starText = tester.widget<Text>(find.text('*'));
        expect(starText.style?.color, equals(Colors.blue));
      });

      testWidgets('should use custom required indicator builder', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              labelText: 'Test Label',
              showRequiredStar: true,
              requiredIndicatorBuilder: (context, labelText) {
                return Text('Custom: $labelText');
              },
            ),
          ),
        );

        expect(find.text('Custom: Test Label'), findsOneWidget);
      });
    });

    group('Visibility Toggle', () {
      testWidgets('should show visibility toggle when obscureText is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(name: 'testField', obscureText: true),
          ),
        );

        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });

      testWidgets('should toggle visibility when visibility button is tapped', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(name: 'testField', obscureText: true),
          ),
        );

        // Initially should show visibility_off icon
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        // Tap the visibility toggle
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        // Should now show visibility icon
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('should use custom visibility icon builder', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              obscureText: true,
              visibilityIconBuilder: (context, isObscured) {
                return Icon(isObscured ? Icons.lock : Icons.lock_open);
              },
            ),
          ),
        );

        expect(find.byIcon(Icons.lock), findsOneWidget);

        // Tap to toggle
        await tester.tap(find.byIcon(Icons.lock));
        await tester.pump();

        expect(find.byIcon(Icons.lock_open), findsOneWidget);
      });

      testWidgets('should use custom visibility toggle builder', (
        tester,
      ) async {
        bool visibilityChanged = false;

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              obscureText: true,
              visibilityToggleBuilder:
                  (context, isObscured, toggle, setObscured) {
                    return ElevatedButton(
                      onPressed: () {
                        toggle();
                        visibilityChanged = true;
                      },
                      child: Text(isObscured ? 'Show' : 'Hide'),
                    );
                  },
            ),
          ),
        );

        expect(find.text('Show'), findsOneWidget);

        await tester.tap(find.text('Show'));
        await tester.pump();

        expect(visibilityChanged, isTrue);
        expect(find.text('Hide'), findsOneWidget);
      });

      testWidgets('should call onVisibilityChanged callback', (tester) async {
        bool? lastVisibilityState;

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              obscureText: true,
              onVisibilityChanged: (context, isObscured) {
                lastVisibilityState = isObscured;
              },
            ),
          ),
        );

        // Tap the visibility toggle
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        expect(lastVisibilityState, isFalse);
      });

      testWidgets(
        'should use setObscured function from visibility toggle builder',
        (tester) async {
          bool? lastVisibilityState;

          await tester.pumpWidget(
            createTestWidget(
              child: CoreTextField(
                name: 'testField',
                obscureText: true,
                onVisibilityChanged: (context, isObscured) {
                  lastVisibilityState = isObscured;
                },
                visibilityToggleBuilder:
                    (context, isObscured, toggle, setObscured) {
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => setObscured(false),
                            child: const Text('Show'),
                          ),
                          ElevatedButton(
                            onPressed: () => setObscured(true),
                            child: const Text('Hide'),
                          ),
                        ],
                      );
                    },
              ),
            ),
          );

          // Test setting to false (show)
          await tester.tap(find.text('Show'));
          await tester.pump();
          expect(lastVisibilityState, isFalse);

          // Test setting to true (hide)
          await tester.tap(find.text('Hide'));
          await tester.pump();
          expect(lastVisibilityState, isTrue);

          // Test setting to same value (should not trigger callback again)
          final previousState = lastVisibilityState;
          await tester.tap(find.text('Hide'));
          await tester.pump();
          expect(lastVisibilityState, equals(previousState));
        },
      );
    });

    group('Clear Functionality', () {
      testWidgets(
        'should show clear button when enableClear is true and field has value',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              child: const CoreTextField(
                name: 'testField',
                enableClear: true,
                initialText: 'Some text',
              ),
            ),
          );

          expect(find.byIcon(Icons.clear), findsOneWidget);
        },
      );

      testWidgets('should not show clear button when field is empty', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(name: 'testField', enableClear: true),
          ),
        );

        expect(find.byIcon(Icons.clear), findsNothing);
      });

      testWidgets('should clear field when clear button is tapped', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              enableClear: true,
              initialText: 'Some text',
            ),
          ),
        );

        expect(find.text('Some text'), findsOneWidget);

        // Tap clear button
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        // Text should be cleared
        expect(find.text('Some text'), findsNothing);
      });

      testWidgets('should use custom clear icon', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              enableClear: true,
              initialText: 'Some text',
              customClearIcon: Icon(Icons.delete),
            ),
          ),
        );

        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byIcon(Icons.clear), findsNothing);
      });
    });

    group('Prefix and Suffix Icons', () {
      testWidgets('should show prefix icon', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              prefixIcon: Icon(Icons.email),
            ),
          ),
        );

        expect(find.byIcon(Icons.email), findsOneWidget);
      });

      testWidgets('should show suffix icon', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('should show multiple prefix icons with obscure text', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              obscureText: true,
              prefixIcon: Icon(Icons.email),
            ),
          ),
        );

        // Should show both prefix icon and visibility toggle
        expect(find.byIcon(Icons.email), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });

      testWidgets('should show multiple suffix icons with clear and suffix', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              enableClear: true,
              suffixIcon: Icon(Icons.search),
              initialText: 'some text',
            ),
          ),
        );

        // Should show both clear icon and suffix icon
        expect(find.byIcon(Icons.clear), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });
    });

    group('Form Integration', () {
      testWidgets('should update form state when text changes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const CoreTextField(name: 'testField')),
        );

        // Enter text
        await tester.enterText(find.byType(TextFormField), 'New Value');
        await tester.pump();

        // Check form state
        expect(formCubit.state.values['testField'], equals('New Value'));
      });

      testWidgets('should show validation errors', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const CoreTextField(name: 'emailField')),
        );

        // Enter invalid email
        await tester.enterText(find.byType(TextFormField), 'invalid-email');
        await tester.pump();

        // Trigger validation
        formCubit.validateFieldImmediately(
          fieldName: 'emailField',
          context: tester.element(find.byType(CoreTextField)),
        );
        await tester.pump();

        // Should show error
        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('should use custom error builder', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'emailField',
              errorBuilder: (context, errorText) {
                return Container(
                  color: Colors.red,
                  child: Text('Custom: $errorText'),
                );
              },
            ),
          ),
        );

        // Enter invalid email and trigger validation
        await tester.enterText(find.byType(TextFormField), 'invalid-email');
        formCubit.validateFieldImmediately(
          fieldName: 'emailField',
          context: tester.element(find.byType(CoreTextField)),
        );
        await tester.pump();

        expect(
          find.text('Custom: Please enter a valid email address'),
          findsOneWidget,
        );
      });
    });

    group('Value Transformation and Formatting', () {
      testWidgets('should transform value before updating form', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              transformValue: (value) => value.toUpperCase(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'lowercase');
        await tester.pump();

        expect(formCubit.state.values['testField'], equals('LOWERCASE'));
      });

      testWidgets('should format displayed text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              initialText: 'test',
              formatText: (value) => 'Formatted: $value',
            ),
          ),
        );

        expect(find.text('Formatted: test'), findsOneWidget);
      });
    });

    group('Debouncing', () {
      testWidgets('should debounce form updates', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              debounceTime: Duration(milliseconds: 100),
            ),
          ),
        );

        // Enter text rapidly
        await tester.enterText(find.byType(TextFormField), 'a');
        await tester.enterText(find.byType(TextFormField), 'ab');
        await tester.enterText(find.byType(TextFormField), 'abc');

        // Form should not be updated immediately
        expect(formCubit.state.values['testField'], isNull);

        // Wait for debounce
        await tester.pump(const Duration(milliseconds: 150));

        // Now form should be updated
        expect(formCubit.state.values['testField'], equals('abc'));
      });
    });

    group('Callbacks', () {
      testWidgets('should call onTap callback', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(name: 'testField', onTap: () => tapped = true),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        expect(tapped, isTrue);
      });

      testWidgets('should call onEditingComplete callback', (tester) async {
        bool editingComplete = false;

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              onEditingComplete: () => editingComplete = true,
            ),
          ),
        );

        // Focus the field first
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        // Send editing complete action
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(editingComplete, isTrue);
      });

      testWidgets('should call onSubmitted callback', (tester) async {
        String? submittedValue;

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              onSubmitted: (value) => submittedValue = value,
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'submitted');
        await tester.testTextInput.receiveAction(TextInputAction.done);

        expect(submittedValue, equals('submitted'));
      });

      testWidgets('should call onTapOutside callback', (tester) async {
        bool tappedOutside = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: formCubit,
                child: Column(
                  children: [
                    CoreTextField(
                      name: 'testField',
                      onTapOutside: (_) => tappedOutside = true,
                    ),
                    const SizedBox(height: 100),
                    const Text('Outside widget'),
                  ],
                ),
              ),
            ),
          ),
        );

        // First focus the text field
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        // Then tap outside
        await tester.tap(find.text('Outside widget'));
        await tester.pump();

        expect(tappedOutside, isTrue);
      });
    });

    group('Focus Management', () {
      testWidgets('should use provided focus node', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(name: 'testField', focusNode: focusNode),
          ),
        );

        // Verify widget renders without error
        expect(find.byType(CoreTextField), findsOneWidget);

        focusNode.dispose();
      });

      testWidgets('should create focus node when not provided', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const CoreTextField(name: 'testField')),
        );

        // Verify widget renders without error
        expect(find.byType(CoreTextField), findsOneWidget);
      });
    });

    group('Input Formatters', () {
      testWidgets('should apply input formatters', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'abc123def');
        await tester.pump();

        // Should only contain digits
        expect(formCubit.state.values['testField'], equals('123'));
      });
    });

    group('Counter Builder', () {
      testWidgets('should use custom counter builder', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              maxLength: 10,
              counterBuilder:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) {
                    return Text('Custom: $currentLength/$maxLength');
                  },
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'test');
        await tester.pump();

        expect(find.text('Custom: 4/10'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null initial text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const CoreTextField(name: 'testField')),
        );

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should handle empty string initial text', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(name: 'testField', initialText: ''),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
      });
    });

    group('Disposal', () {
      testWidgets('should dispose resources properly', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(name: 'testField', focusNode: focusNode),
          ),
        );

        // Remove widget
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Focus node should not be disposed (it was provided externally)
        expect(focusNode.hasFocus, isFalse);

        focusNode.dispose();
      });

      testWidgets('should dispose internal focus node', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const CoreTextField(name: 'testField')),
        );

        // Remove widget - should not throw
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // No exception should be thrown
      });
    });

    group('Switch Prefix and Suffix', () {
      testWidgets('should switch prefix and suffix positions', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              prefixIcon: Icon(Icons.email),
              suffixIcon: Icon(Icons.search),
              switchBetweenPrefixAndSuffix: true,
            ),
          ),
        );

        // Both icons should be present
        expect(find.byIcon(Icons.email), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });
    });

    group('Advanced Icon Combinations', () {
      testWidgets('should handle multiple prefix icons in a Row', (
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

        // Should have both prefix icon and visibility toggle
        expect(find.byIcon(Icons.email), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        // Should create a Row widget for multiple icons
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('should handle multiple suffix icons in a Row', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              enableClear: true,
              suffixIcon: Icon(Icons.search),
              initialText: 'test',
            ),
          ),
        );

        // Should have both clear icon and suffix icon
        expect(find.byIcon(Icons.clear), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);

        // Should create a Row widget for multiple icons
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('should handle single prefix icon without Row', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              prefixIcon: Icon(Icons.email),
            ),
          ),
        );

        expect(find.byIcon(Icons.email), findsOneWidget);
      });

      testWidgets('should handle single suffix icon without Row', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });
    });

    group('Form Value Synchronization', () {
      testWidgets('should sync controller when form value changes', (
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

        // Update form value externally
        formCubit.updateField(
          fieldName: 'testField',
          value: 'updated',
          context: tester.element(find.byType(CoreTextField)),
        );
        await tester.pump();

        // Controller should be updated
        expect(find.text('updated'), findsOneWidget);
        expect(find.text('initial'), findsNothing);
      });

      testWidgets('should format text when form value changes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              formatText: (value) => 'Formatted: $value',
            ),
          ),
        );

        // Update form value
        formCubit.updateField(
          fieldName: 'testField',
          value: 'test',
          context: tester.element(find.byType(CoreTextField)),
        );
        await tester.pump();

        expect(find.text('Formatted: test'), findsOneWidget);
      });

      testWidgets('should handle null value in formatText', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CoreTextField(
              name: 'testField',
              formatText: (value) => 'Formatted: $value',
            ),
          ),
        );

        // Form value is null by default, should handle gracefully
        expect(find.byType(TextFormField), findsOneWidget);
      });
    });

    group('Label Widget Combinations', () {
      testWidgets(
        'should not show label widget when showRequiredStar is false',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              child: const CoreTextField(
                name: 'testField',
                labelText: 'Test Label',
              ),
            ),
          );

          expect(find.text('Test Label'), findsOneWidget);
          expect(find.text('*'), findsNothing);
        },
      );

      testWidgets('should handle labelText null with showRequiredStar true', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: const CoreTextField(
              name: 'testField',
              showRequiredStar: true,
            ),
          ),
        );

        // Should not create label widget when labelText is null
        expect(find.text('*'), findsNothing);
      });
    });
  });
}
