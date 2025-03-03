import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A Bloc observer that logs events, state changes, transitions, errors,
/// creation, and closure of blocs using an injected [AppLogger] instance.
class CoreBlocObserver extends BlocObserver {

  /// Creates a new [CoreBlocObserver] with the given [logger].
  CoreBlocObserver(this.logger);
  /// The logger instance used for logging Bloc events and changes.
  final CoreLogger logger;

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.info('Event: ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.info('Change: ${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.info('Transition: ${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.error('Error in ${bloc.runtimeType}', error, stackTrace);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logger.info('${bloc.runtimeType} created');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    logger.info('${bloc.runtimeType} closed');
  }
}
