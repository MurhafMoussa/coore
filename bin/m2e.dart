import 'dart:io';

Future<void> main() async {
  try {
    stdin.lineMode = true;
    stdin.echoMode = true;

    stdout.write('Enter Model class name: ');

    final modelClassName = stdin.readLineSync()?.trim();

    stdout.write('Enter Entity class name: ');

    final entityClassName = stdin.readLineSync()?.trim();

    stdout.write('Enter Model file path: ');

    final rawModelPath = stdin.readLineSync()?.trim() ?? '';
    final modelFilePath = File(rawModelPath).absolute.path;

    stdout
      ..write('\n--- Input Summary ---')
      ..write('Model Class: $modelClassName')
      ..write('Entity Class: $entityClassName')
      ..write('File Path: $modelFilePath');

    if (modelClassName == null ||
        modelClassName.isEmpty ||
        entityClassName == null ||
        entityClassName.isEmpty ||
        rawModelPath.isEmpty) {
      throw Exception('Missing inputs');
    }

    final file = File(modelFilePath);

    stdout.write('\nChecking file existence...');

    if (!file.existsSync()) {
      throw Exception('File not found');
    }

    stdout.write('Reading file content...');

    final content = await file.readAsString();

    stdout.write('File content length: ${content.length} characters');

    final fieldRegex = RegExp(
      r'^\s*((?:final\s+|late final\s+)?)([\w<>]+)\?(\s+\w+\s*),?$',
      multiLine: true,
    );
    final matches = fieldRegex.allMatches(content).toList();

    stdout.write('\nFound ${matches.length} potential nullable fields');

    if (matches.isEmpty) {
      stdout
        ..write(
          '⚠ No nullable fields found - ensure your model class contains lines like:',
        )
        ..write('  String? name;')
        ..write('  List<int>? numbers;');

      return;
    }

    final lines = <String>[];
    for (final match in matches) {
      try {
        final fullMatch = match.group(0);
        final type = match.group(2);
        final fieldName = match.group(3)?.trim();

        stdout
          ..write('\nProcessing field: $fullMatch')
          ..write('Type: $type | Field: $fieldName');

        if (type == null || fieldName == null) {
          stdout.write('⚠ Skipping invalid match: ${match.group(0)}');

          continue;
        }

        String mappingLine;

        // Use the Defaults class to provide a fallback value if the field is null.
        if (type == 'int') {
          mappingLine = '$fieldName: $fieldName ?? Defaults.defaultInt,';
        } else if (type == 'String') {
          mappingLine = '$fieldName: $fieldName ?? Defaults.defaultString,';
        } else if (type == 'double') {
          mappingLine = '$fieldName: $fieldName ?? Defaults.defaultDouble,';
        } else if (type == 'bool') {
          mappingLine = '$fieldName: $fieldName ?? Defaults.defaultBool,';
        } else if (type == 'num') {
          mappingLine = '$fieldName: $fieldName ?? Defaults.defaultNum,';
        } else if (type.startsWith('List<')) {
          // Handle List types by extracting the inner type.
          final innerMatch = RegExp(r'List<\s*(\S+)\s*>').firstMatch(type);
          if (innerMatch != null) {
            final innerType = innerMatch.group(1);
            // If the inner type is primitive, use the default empty list.
            if (innerType != null &&
                [
                  'int',
                  'String',
                  'double',
                  'bool',
                  'num',
                ].contains(innerType)) {
              mappingLine = '$fieldName: $fieldName ?? Defaults.defaultList,';
            } else {
              // For non-primitive inner types, assume a toEntity() conversion is needed.
              mappingLine =
                  '$fieldName: $fieldName?.map((e) => e.toEntity()).toList() ?? Defaults.defaultList,';
            }
          } else {
            mappingLine = '$fieldName: $fieldName ?? Defaults.defaultList,';
          }
        } else if (type == 'Map') {
          mappingLine = '$fieldName: $fieldName ?? Defaults.defaultMap,';
        } else if (type == 'DateTime') {
          // For DateTime fields, use a default provided by Defaults (e.g., current local time).
          mappingLine = '$fieldName: $fieldName ?? Defaults.defaultDateTime,';
        } else {
          // For any other type, assume a toEntity() conversion exists.
          mappingLine =
              '$fieldName: $fieldName?.toEntity() ?? const $type().toEntity(),';
        }
        lines.add('    $mappingLine');

        stdout.write(' Generated mapping: $mappingLine');
      } catch (e) {
        stdout.write('⚠ Error processing match: $e');
      }
    }

    if (lines.isEmpty) {
      stdout.write(
        '\n No valid fields processed - check your model field formatting',
      );

      return;
    }

    final extensionCode = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

extension ${modelClassName}ToEntity on $modelClassName {
  $entityClassName get toEntity => $entityClassName(
${lines.join('\n')}
  );
}
''';

    stdout
      ..write('\nGenerated Extension Code:\n${'═' * 40}')
      ..write(extensionCode)
      ..write('═' * 40)
      ..write('\nWriting to file...');

    await file.writeAsString('\n\n$extensionCode', mode: FileMode.append);

    stdout.write(' Successfully updated $modelFilePath');
  } catch (e) {
    stdout
      ..write('\n❌ Error: $e')
      ..write('Stack trace: ${StackTrace.current}');
  } finally {
    stdin.lineMode = false;
    stdin.echoMode = false;
  }
}
