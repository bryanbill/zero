import 'dart:io';

import 'package:watcher/watcher.dart';
import 'package:yaml/yaml.dart';

/// This file contains the command line interface for the zero package.
/// It is the entry point for the command line tool.
void main(List<String> arguments) {
  print("--zero--");

  if (arguments.isEmpty) {
    // print usage
    print("Usage: zero <command> [arguments]");
    print("Commands:");
    print("  new <project name> - Creates a new zero project");
    print("  run -w - Runs the project in development mode");
    print(
        "  get <package name> ... - Installs dart packages compatible with zero");
    return;
  }

  switch (arguments[0]) {
    case "new":
      ZeroCli.create(arguments.sublist(1));
      break;

    case "run":
      ZeroCli.run(arguments.sublist(1));
      break;
    case "get":
      ZeroCli.get(arguments.sublist(1));
      break;
    default:
      print("Unknown command '${arguments[0]}'");
  }
}

/// Command line interface for the zero package.
///
/// This class is used to create new zero projects, and to build and run zero
/// projects.
///
/// The command line tool is also used to install and manage zero packages.
///
/// Supported commands:
/// - `zero new <project name>` - Creates a new zero project
/// - `zero build -o .` Compiles the project
/// - `zero run -w` - Runs the project in development mode
/// - `zero get <package name> ...` - Installs dart packages compatible with zero
class ZeroCli {
  /// Creates a new zero project with the given name.
  static void create(List<String> args) {
    if (args.isEmpty) {
      print("Usage: zero create <project name>");
      return;
    }

    final projectName = args[0];
    final projectDirectory = "${Directory.current.path}/$projectName";

    if (Directory(projectDirectory).existsSync()) {
      print("Directory '$projectDirectory' already exists");
      return;
    }

    Directory(projectDirectory).createSync(recursive: true);

    final pubspecFile = File("$projectDirectory/pubspec.yaml")..createSync();

    pubspecFile.writeAsStringSync("""
name: $projectName
version: 0.0.1
description: A zero project
main: lib/main.dart
environment:
  sdk: '>=2.12.0 <4.0.0'
dependencies:
  zero:
    git:
      url: https://github.com/bryanbill/zero 

dev_dependencies:
  lint: ^2.0.0
  test: ^1.21.0
""");

    final mainFile = File("$projectDirectory/lib/main.dart")
      ..createSync(recursive: true);
    mainFile.writeAsStringSync(
      """
import 'package:zero/zero.dart';

void main() {
  final zero = Server(
    routes: [
      Route(
        path: '/',
        controller: (req) => IndexController(req)
      )
    ]
  );

  zero.run();

  print('Listening on port \${zero.port}');
}

class IndexController extends Controller {
  IndexController(Request request) : super(request);

  @Path('/')
  Response hello() {
    return Response.ok('Hello world!');
  }
}
""",
    );

    print("Created project '$projectName' in '$projectDirectory'");

    print("Installing dependencies...");

    final process = Process.runSync('dart', ['pub', 'get'],
        workingDirectory: projectDirectory);

    stdout.write(process.stdout);
    stderr.write(process.stderr);

    print("Done");
    print("Run 'cd $projectDirectory && zero run' to start the project");
  }

  /// Runs the project in development mode.
  ///
  /// File watcher is enabled by default to watch for changes in the project files
  /// and recompile the project when changes are detected.
  /// To disable file watcher, use the `--no-watch` flag.
  ///
  /// The default output directory is `./build`.
  static void run(List<String> args) async {
    final pubspecFile = File('${Directory.current.path}/pubspec.yaml');

    final entry = loadYaml(pubspecFile.readAsStringSync())
            .cast<String, dynamic>()['main'] ??
        'lib/main.dart';

    var process = await Process.start('dart', ['run', entry]);

    process.stdout.listen((event) {
      print(String.fromCharCodes(event));
    });

    process.stderr.listen((event) {
      print(String.fromCharCodes(event));
    });

    if (args.contains('--no-watch')) {
      stdout.addStream(process.stdout);
      stderr.addStream(process.stderr);
    } else {
      final watcher = Watcher(Directory.current.path);
      await for (final event in watcher.events) {
        if (event.type == ChangeType.MODIFY) {
          process.kill();

          process = await Process.start('dart', ['run', entry]);

          process.stdout.listen((event) {
            print(String.fromCharCodes(event));
          });

          process.stderr.listen((event) {
            print(String.fromCharCodes(event));
          });
        }
      }
    }
  }

  /// Installs the given packages.
  static void get(List<String> args) {
    for (final package in args) {
      final process = Process.runSync('dart', ['pub', 'get', package]);
      if (process.exitCode != 0) {
        print(process.stderr);
        exit(1);
      }
    }
  }
}
