import 'dart:io';

String saveFile(File file, [String? path]) {
  final name = file.path.split('/').last;
  final newPath = path ?? 'uploads/$name';
  file.copySync(newPath);
  return newPath;
}
