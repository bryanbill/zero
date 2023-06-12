import 'dart:io';

class Meta {
  final String? path;

  const Meta({this.path});

  Map<String, dynamic> get env => _loadEnv();

  Map<String, dynamic> _loadEnv() {
    final file = File(path ?? '.env');
    if (!file.existsSync()) {
      return {};
    }
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

const meta = Meta();