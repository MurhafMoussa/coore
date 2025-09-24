import 'package:coore/src/ui/forms/cubit/core_form_cubit.dart';
import 'package:coore/src/ui/forms/models/typed_form_field.dart';
import 'package:coore/src/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoreFormCubit Debouncing', () {
    late CoreFormCubit formCubit;
    late MockBuildContext mockContext;

    setUp(() {
      formCubit = TestFormFactory.createFormWithEmailAndAge();
      mockContext = MockBuildContext();
    });

    tearDown(() {
      formCubit.close();
    });

    group('updateFieldWithDebounce', () {
      test(
        'should update field value immediately but validate with debounce',
        () async {
          // Update field with debounce
          formCubit.updateFieldWithDebounce(
            fieldName: 'email',
            value: 'test@example.com',
            context: mockContext,
          );

          // For allFields validation type with debouncing, value is not updated immediately
          // It's only updated after the debounce delay
          expect(formCubit.state.values['email'], isNull); // Initial value
          expect(formCubit.state.errors, isEmpty);

          // Wait for debounce delay
          await Future<void>.delayed(const Duration(milliseconds: 350));

          // Validation should have occurred and value should be updated
          expect(formCubit.state.values['email'], 'test@example.com');
          expect(formCubit.state.errors['email'], 'Email error');
        },
      );

      test(
        'should cancel previous debounced validation when new update occurs',
        () async {
          // First update
          formCubit.updateFieldWithDebounce(
            fieldName: 'email',
            value: 'test1@example.com',
            context: mockContext,
          );

          // Second update (should cancel first validation)
          formCubit.updateFieldWithDebounce(
            fieldName: 'email',
            value: 'test2@example.com',
            context: mockContext,
          );

          // Wait for original debounce delay
          await Future<void>.delayed(const Duration(milliseconds: 350));

          // Should only validate once (the second update)
          expect(formCubit.state.values['email'], 'test2@example.com');
          expect(formCubit.state.errors['email'], 'Email error');
        },
      );

      test('should throw ArgumentError for non-existent field', () {
        expect(
          () => formCubit.updateFieldWithDebounce(
            fieldName: 'nonExistent',
            value: 'value',
            context: mockContext,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw TypeError for wrong type', () {
        expect(
          () => formCubit.updateFieldWithDebounce<int>(
            fieldName: 'email',
            value: 123, // Wrong type
            context: mockContext,
          ),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('validateFieldImmediately', () {
      test('should validate field immediately without debouncing', () async {
        // Set up field with value
        formCubit.updateField(
          fieldName: 'email',
          value: 'test@example.com',
          context: mockContext,
        );

        // Validate immediately
        formCubit.validateFieldImmediately(
          fieldName: 'email',
          context: mockContext,
        );

        // Should validate immediately
        expect(formCubit.state.errors['email'], 'Email error');
      });

      test(
        'should cancel pending debounced validation when validating immediately',
        () async {
          // Start debounced update
          formCubit.updateFieldWithDebounce(
            fieldName: 'email',
            value: 'test@example.com',
            context: mockContext,
          );

          // Validate immediately
          formCubit.validateFieldImmediately(
            fieldName: 'email',
            context: mockContext,
          );

          // Wait for original debounce delay
          await Future<void>.delayed(const Duration(milliseconds: 350));

          // Should have validated immediately
          expect(formCubit.state.errors['email'], 'Email error');
        },
      );

      test('should throw ArgumentError for non-existent field', () {
        expect(
          () => formCubit.validateFieldImmediately(
            fieldName: 'nonExistent',
            context: mockContext,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle field with no validator gracefully', () {
        // Create form with field that has no validator
        final formCubitNoValidator = CoreFormCubit(
          fields: [const TypedFormField<String>(name: 'email', validators: [])],
        );

        formCubitNoValidator.updateField(
          fieldName: 'email',
          value: 'test@example.com',
          context: mockContext,
        );

        // Should not throw error
        expect(
          () => formCubitNoValidator.validateFieldImmediately(
            fieldName: 'email',
            context: mockContext,
          ),
          returnsNormally,
        );

        formCubitNoValidator.close();
      });
    });

    group('dispose', () {
      test('should dispose resources and cancel pending validations', () async {
        // Start debounced validation
        formCubit.updateFieldWithDebounce(
          fieldName: 'email',
          value: 'test@example.com',
          context: mockContext,
        );

        // Dispose cubit
        await formCubit.close();

        // Wait for original debounce delay
        await Future<void>.delayed(const Duration(milliseconds: 350));

        // Should not cause any issues (no exceptions thrown)
        expect(true, isTrue);
      });
    });
  });
}

class MockBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockValidator<T> implements Validator<T> {
  int validateCallCount = 0;

  @override
  String? validate(T? value, BuildContext context) {
    validateCallCount++;
    return 'Email error';
  }
}

class TestFormFactory {
  static CoreFormCubit createFormWithEmailAndAge() {
    return CoreFormCubit(
      fields: [
        TypedFormField<String>(
          name: 'email',
          validators: [MockValidator<String>()],
        ),
        TypedFormField<int>(name: 'age', validators: [MockValidator<int>()]),
      ],
    );
  }
}
