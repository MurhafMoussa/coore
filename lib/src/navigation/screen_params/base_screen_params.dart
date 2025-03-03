/// Abstract class for screen parameters.
library;

import 'package:equatable/equatable.dart';

abstract class BaseScreenParams extends Equatable {
  const BaseScreenParams();

  Map<String, dynamic> get queryParams => {};

  Map<String, String> get pathParams => {};

  Map<String, Object> get extra => {};

  @override
  List<Object?> get props => [queryParams, pathParams, extra];
}
