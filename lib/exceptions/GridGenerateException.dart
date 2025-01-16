class GridGenerateException implements Exception {
  final String message;

  GridGenerateException(this.message);

  @override
  String toString() {
    return 'Error: $message';
  }
}
