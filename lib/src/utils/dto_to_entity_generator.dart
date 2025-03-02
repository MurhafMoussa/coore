import 'dart:io';

/// Runs the extension method generator for a DTO class.
///
/// This script prompts the user to input the DTO class name, the entity class name,
/// and the file path where the DTO is defined. It reads the file to find all nullable
/// fields (using a regular expression), then creates mapping lines that convert each DTO
/// field to a non‑nullable field for the entity, using default values provided by the
/// `Defaults` class if the DTO field is null.
///
/// Finally, the script generates an extension method that adds a `toEntity` getter to the DTO,
/// printing the generated code and appending it to the specified DTO file.
Future<void> main() async {
  // Prompt for the DTO class name.
  stdout.write('Enter DTO class name: ');
  final dtoClassName = stdin.readLineSync();

  // Prompt for the entity class name.
  stdout.write('Enter entity class name: ');
  final entityClassName = stdin.readLineSync();

  // Prompt for the file path of the DTO.
  stdout.write('Enter DTO file path: ');
  final dtoFilePath = stdin.readLineSync();

  // Validate the inputs; if any input is null or empty, exit the script.
  if (dtoClassName == null ||
      entityClassName == null ||
      dtoFilePath == null ||
      dtoClassName.isEmpty ||
      entityClassName.isEmpty ||
      dtoFilePath.isEmpty) {
    print('One or more inputs were invalid.');
    return;
  }

  // Create a File instance for the given DTO file path.
  final file = File(dtoFilePath);
  if (!await file.exists()) {
    print('File not found at $dtoFilePath');
    return;
  }

  // Read the content of the file as a string.
  final content = await file.readAsString();

  // Use a regular expression to match nullable field declarations.
  // Example match: "final int? id;" where group(1) is "int" and group(2) is "id".
  final fieldRegex = RegExp(r'final\s+(\S+)\?\s+(\S+);');
  final matches = fieldRegex.allMatches(content).toList();

  // If no nullable fields are found, print a message and exit.
  if (matches.isEmpty) {
    print('No nullable fields were found in the file.');
    return;
  }

  // Generate mapping lines for each field. These lines will be used in the extension method.
  final lines = <String>[];
  for (final match in matches) {
    // Extract the type (without the '?') and field name.
    final type = match.group(1);
    final fieldName = match.group(2);

    // Skip iteration if type or fieldName is not captured.
    if (type == null || fieldName == null) continue;

    String mappingLine;

    // Use the Defaults class to provide a fallback value if the field is null.
    if (type == 'int') {
      mappingLine = '$fieldName: $fieldName ?? Defaults.defaultInt,';
    } else if (type == 'String') {
      mappingLine = "$fieldName: $fieldName ?? Defaults.defaultString,";
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
            ['int', 'String', 'double', 'bool', 'num'].contains(innerType)) {
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
    // Add the mapping line with proper indentation.
    lines.add('    $mappingLine');
  }

  // Generate the complete extension method code using the mapping lines.
  final extensionCode = '''
extension ${dtoClassName}X on $dtoClassName {
  $entityClassName get toEntity => $entityClassName(
${lines.join('\n')}
  );
}
''';

  // Print the generated extension method code.
  print('\nGenerated extension method:\n');
  print(extensionCode);

  // Append the generated extension method code to the DTO file.
  await file.writeAsString('\n$extensionCode', mode: FileMode.append);
  print('Extension method appended to $dtoFilePath');
}
