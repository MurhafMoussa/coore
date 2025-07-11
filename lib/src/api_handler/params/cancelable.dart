import 'package:coore/src/api_handler/cancel_request_adapter.dart';

/// Anything that can carry an optional CancelRequestAdapter
/// and be “cloned” with a new one.
abstract interface class Cancelable {
  CancelRequestAdapter? get cancelRequestAdapter;

  /// Return a copy of `this` with a different [cancelTokenAdapter].
  Cancelable copyWithCancelRequest(CancelRequestAdapter cancelTokenAdapter);
}
