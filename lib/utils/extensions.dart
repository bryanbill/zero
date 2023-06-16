import 'dart:io';

extension HttpHeaderExtension on HttpHeaders {
  /// Adds all object entries to the headers.
  void addAll(Map<String, String> headers) {
    headers.forEach((key, value) {
      add(key, value);
    });
  }
}
