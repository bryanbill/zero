import 'dart:io';

class Env {
  final String? path;

  Env({this.path}){
    _env = _loadEnv();
  }

  Map<String, dynamic> get env => _env;

  Map<String, dynamic> _env = {};

  Map<String, dynamic> _loadEnv() {
    final file = File(path ?? '.env');
    final lines = file.readAsLinesSync();
    final env = <String, dynamic>{};
    for (final line in lines) {
      if (line.startsWith('#')) {
        continue;
      }
      final parts = line.split('=');
      if (parts.length < 2) {
        continue;
      }
      final key = parts[0].trim();
      final value = parts[1].trim();
      env[key] = value;
    }
    return env;
  }
}