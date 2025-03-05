import 'package:coore/lib.dart';
import 'package:fpdart/fpdart.dart';

/// Wraps a repository request with an internet connectivity check and error handling.
///
/// This higher‑order function accepts a callback [onConnect] that performs the repository
/// call (returning a [RepositoryFutureResponse<T>]). It first checks for an internet
/// connection; if there isn’t one, [onDisconnect] will perform a call if it's not null or it will
/// returns a [NoInternetConnectionFailure].
/// Otherwise, it executes the [onConnect] inside a try/catch block. If an exception is caught,
/// an [UnknownFailure] is returned.
///
/// This pattern allows you to reuse the connectivity and error‑handling logic for all
/// repository calls in a functional programming style.
Future<Either<Failure, T>> safeRepositoryCall<T>({
  required Future<Either<Failure, T>> Function() onConnect,
  Future<Either<Failure, T>> Function()? onDisconnect,
  required String Function() getNoInternetConnectionMessage,
}) async {
  try {
    if (!await getIt<NetworkStatusInterface>().isConnected) {
      if (onDisconnect != null) return await onDisconnect.call();
      return left(
        NoInternetConnectionFailure(getNoInternetConnectionMessage()),
      );
    }
    return await onConnect();
  } on Exception catch (_, stackTrace) {
    return left(UnknownFailure(stackTrace));
  }
}
