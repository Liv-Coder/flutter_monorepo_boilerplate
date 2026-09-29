/// Thrown when a storage operation fails.
class StorageException implements Exception {
  const StorageException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() =>
      'StorageException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}
