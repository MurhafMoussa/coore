import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as path;

extension FileExtension on File {
  /// Get the file name with the extension from the full file path
  String get fileName => path.basename(this.path);

  /// Get the file name without the extension
  String get fileNameWithoutExtension =>
      path.basenameWithoutExtension(this.path);

  /// Get the file extension (without the dot)
  String get fileExtension => path.extension(this.path).replaceFirst('.', '');

  /// Get parent directory path
  String get parentPath => path.dirname(this.path);

  /// Get parent directory as a Directory object
  Directory get parentDirectory => Directory(parentPath);

  /// Get file size in bytes (synchronous)
  int get sizeSync => lengthSync();

  /// Get file size in bytes (asynchronous)
  Future<int> get size async => (await stat()).size;

  /// Get human-readable file size (e.g., '2.5 MB')
  Future<String> get humanReadableSize async {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    final bytes = await size;
    if (bytes <= 0) return '0 B';
    final digitGroups = min((log(bytes) / log(1024)).floor(), units.length - 1);
    final formattedSize = (bytes / pow(1024, digitGroups)).toStringAsFixed(1);
    return '$formattedSize ${units[digitGroups]}';
  }

  /// Checks if the file has an image extension
  bool get isImage => _imageExtensions.contains(fileExtension.toLowerCase());

  /// Checks if the file has a video extension
  bool get isVideo => _videoExtensions.contains(fileExtension.toLowerCase());

  /// Checks if the file has a text extension
  bool get isText => _textExtensions.contains(fileExtension.toLowerCase());

  /// Checks if the file has a document extension
  bool get isDocument =>
      _documentExtensions.contains(fileExtension.toLowerCase());

  /// Copies the file to a new location with optional new name
  Future<File> copyTo(Directory destination, {String? newName}) async {
    final fileName = newName ?? this.fileName;
    return copy(path.join(destination.path, fileName));
  }

  /// Creates parent directories if they don't exist
  Future<void> ensureParentExists() => parentDirectory.create(recursive: true);

  /// Gets MIME type based on file extension
  String? get contentType {
    switch (fileExtension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      case 'pdf':
        return 'application/pdf';
      case 'txt':
        return 'text/plain';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      case 'tar':
        return 'application/x-tar';
      case 'gz':
        return 'application/gzip';
      default:
        return null;
    }
  }

  /// Get relative path from [from]
  String relativePath(String from) => path.relative(this.path, from: from);

  // Extension sets
  static final _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'};
  static final _videoExtensions = {'mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'};
  static final _textExtensions = {
    'txt',
    'dart',
    'json',
    'xml',
    'html',
    'css',
    'js',
  };
  static final _documentExtensions = {
    'pdf',
    'doc',
    'docx',
    'ppt',
    'pptx',
    'xls',
    'xlsx',
  };
}
