import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:fpdart/fpdart.dart';

/// Interface for NoSQL database operations with functional error handling.
///
/// This interface provides a comprehensive set of operations for managing
/// key-value data with reactive updates through Hive's native capabilities.
///
/// All operations return [CacheResponse<T>] which is a [Future<Either<CacheFailure, T>>],
/// enabling functional error handling patterns.
abstract interface class NoSqlDatabaseInterface {
  // ============================================================================
  // Lifecycle Management
  // ============================================================================

  /// Initializes the database connection.
  ///
  /// Must be called before any other operations.
  /// Returns [Unit] on success or [CacheInitializationFailure] on error.
  CacheResponse<Unit> initialize();

  /// Closes the database connection and releases resources.
  ///
  /// Should be called when the database is no longer needed.
  /// Returns [Unit] on success or [CacheFailure] on error.
  CacheResponse<Unit> close();

  /// Deletes the database from disk completely.
  ///
  /// The box must be closed before calling this method.
  /// Returns [Unit] on success or [CacheFailure] on error.
  CacheResponse<Unit> deleteFromDisk();

  // ============================================================================
  // Write Operations
  // ============================================================================

  /// Saves a value with the given key (uses Hive's Box.put).
  ///
  /// If the key already exists, its value will be overwritten.
  /// Returns [Unit] on success or [CacheWriteFailure] on error.
  CacheResponse<Unit> save<T>(String key, T value);

  /// Saves multiple key-value pairs in a batch operation (uses Hive's Box.putAll).
  ///
  /// More efficient than multiple individual [save] calls.
  /// Returns [Unit] on success or [CacheWriteFailure] on error.
  CacheResponse<Unit> saveAll<T>(Map<String, T> entries);

  // ============================================================================
  // Read Operations
  // ============================================================================

  /// Retrieves the value associated with the given key (uses Hive's Box.get).
  ///
  /// Returns the value if found, `null` if not found, or [CacheReadFailure] on error.
  CacheResponse<T?> get<T>(String key);

  /// Retrieves the value or returns a default value if not found (uses Hive's Box.get with defaultValue).
  ///
  /// Returns the value or [defaultValue] if key doesn't exist, or [CacheReadFailure] on error.
  CacheResponse<T> getOrDefault<T>(String key, T defaultValue);

  /// Retrieves all key-value pairs from the database (uses Hive's Box.toMap).
  ///
  /// Returns a map of all entries or [CacheReadFailure] on error.
  CacheResponse<Map<String, T>> getAll<T>();

  /// Retrieves all keys in the database (uses Hive's Box.keys).
  ///
  /// Returns a list of all keys or [CacheReadFailure] on error.
  CacheResponse<List<String>> getKeys();

  /// Retrieves all values in the database (uses Hive's Box.values).
  ///
  /// Returns a list of all values or [CacheReadFailure] on error.
  CacheResponse<List<T>> getValues<T>();

  /// Gets the value at a specific index (uses Hive's Box.getAt).
  ///
  /// Returns the value at [index] or [CacheReadFailure] on error.
  CacheResponse<T> getAt<T>(int index);

  // ============================================================================
  // Delete Operations
  // ============================================================================

  /// Deletes the value associated with the given key (uses Hive's Box.delete).
  ///
  /// Returns [Unit] on success or [CacheDeleteFailure] on error.
  CacheResponse<Unit> delete(String key);

  /// Deletes multiple keys in a batch operation (uses Hive's Box.deleteAll).
  ///
  /// Returns [Unit] on success or [CacheDeleteFailure] on error.
  CacheResponse<Unit> deleteAll(Iterable<String> keys);

  /// Clears all data from the database (uses Hive's Box.clear).
  ///
  /// Returns [Unit] on success or [CacheDeleteFailure] on error.
  CacheResponse<Unit> clear();

  /// Deletes the value at a specific index (uses Hive's Box.deleteAt).
  ///
  /// Returns [Unit] on success or [CacheDeleteFailure] on error.
  CacheResponse<Unit> deleteAt(int index);

  // ============================================================================
  // Query Operations
  // ============================================================================

  /// Checks if a key exists in the database (uses Hive's Box.containsKey).
  ///
  /// Returns `true` if the key exists, `false` otherwise.
  CacheResponse<bool> contains(String key);

  /// Returns the number of entries in the database (uses Hive's Box.length).
  ///
  /// Returns the count or [CacheReadFailure] on error.
  CacheResponse<int> count();

  /// Checks if the database is empty (uses Hive's Box.isEmpty).
  ///
  /// Returns `true` if empty, `false` otherwise.
  CacheResponse<bool> isEmpty();

  // ============================================================================
  // Reactive Updates
  // ============================================================================

  /// Watches a specific key for changes.
  ///
  /// Returns a stream that emits the current value whenever the key changes.
  /// The stream emits immediately with the current value.
  ///
  /// Example:
  /// ```dart
  /// db.watch<String>('theme').listen((theme) {
  ///   print('Theme changed: $theme');
  /// });
  /// ```
  Stream<T?> watch<T>(String key);

  /// Watches multiple keys for changes.
  ///
  /// Returns a stream that emits a map of the watched keys whenever any of them change.
  /// More efficient than watching keys individually.
  ///
  /// Example:
  /// ```dart
  /// db.watchKeys<String>(['theme', 'language']).listen((data) {
  ///   print('Settings changed: $data');
  /// });
  /// ```
  Stream<Map<String, T>> watchKeys<T>(List<String> keys);

  /// Watches all database changes.
  ///
  /// Returns a stream that emits all key-value pairs whenever any change occurs.
  ///
  /// Example:
  /// ```dart
  /// db.watchAll<dynamic>().listen((allData) {
  ///   print('Database changed: ${allData.length} entries');
  /// });
  /// ```
  Stream<Map<String, T>> watchAll<T>();
}
