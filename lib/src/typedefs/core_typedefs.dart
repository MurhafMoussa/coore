import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:fpdart/fpdart.dart';

typedef ApiResponse<T> = TaskEither<NetworkFailure, T>;

/// A callback used to track the download or upload progress

typedef ProgressTrackerCallback = void Function(double progress);
