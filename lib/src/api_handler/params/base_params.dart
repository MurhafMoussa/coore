import 'package:coore/src/api_handler/cancel_request_adapter.dart';
import 'package:equatable/equatable.dart';

abstract class BaseParams extends Equatable {
  const BaseParams({this.cancelTokenAdapter});

  final CancelRequestAdapter? cancelTokenAdapter;

  Map<String, dynamic> toJson();

  BaseParams attachCancelToken({CancelRequestAdapter? cancelTokenAdapter});
}

abstract class BaseAsyncParams extends Equatable {
  const BaseAsyncParams({required this.cancelTokenAdapter});

  final CancelRequestAdapter cancelTokenAdapter;

  Future<Map<String, dynamic>> toJson();
}
