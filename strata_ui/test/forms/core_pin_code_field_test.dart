import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strata_ui/strata_ui.dart';
import 'package:typed_form_fields/typed_form_fields.dart';

void main() {
  group('CorePinCodeField Widget Tests', () {
    testWidgets('renders pin code input field', (tester) async {
      String? completedPin;

      await tester.pumpWidget(
        MaterialApp(
          home: TypedFormProvider(
            fields: const [
              FormFieldDefinition<String>(
                name: 'pin',
                validators: [],
                initialValue: '',
              ),
            ],
            child: (context) => Scaffold(
              body: CorePinCodeField(
                name: 'pin',
                length: 4,
                onCompleted: (pin) => completedPin = pin,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CorePinCodeField), findsOneWidget);
      expect(completedPin, isNull);
    });
  });
}
