import 'package:zero/zero.dart';

/// Route class for registering routes.
///
/// This class is used to register routes. It is used by the [Server] class to
/// register routes for the server to handle.
///
/// Example:
/// ```dart
/// final route = Route(
///  path: '/hello',
/// controller: (request) => MyController(request),
/// );
/// ```
class Route {
  final String path;
  final Controller Function(Request request) controller;

  Route({
    required this.path,
    required this.controller,
  });

  @override
  String toString() {
    return 'Route(path: $path, controller: $controller)';
  }
}
