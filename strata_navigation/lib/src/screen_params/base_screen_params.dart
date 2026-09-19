import 'package:equatable/equatable.dart';

/// Abstract class for screen parameters.
abstract class const BaseScreenParams() extends Equatable {
  /// Query parameters map.
  Map<String, dynamic> get queryParams => {};

  /// Path parameters map.
  Map<String, String> get pathParams => {};

  /// Extra object parameters map.
  Map<String, Object> get extra => {};

  @override
  List<Object?> get props => [queryParams, pathParams, extra];
}
