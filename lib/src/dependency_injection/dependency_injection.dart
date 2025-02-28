import 'package:coore/src/dev_tools/core_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

Future<void> setupCoreDependencies() async {
  getIt
    ..registerLazySingleton(
      () => Logger(
        filter: DevelopmentFilter(),
        printer: PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime),
        output: ConsoleOutput(),
        level: Level.all,
      ),
    )
    ..registerLazySingleton<CoreLogger>(() => CoreLoggerImpl(getIt()));
}
