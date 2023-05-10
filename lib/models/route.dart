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

/// Path annotation for specifying the path and HTTP method of a controller.
///
/// Default method is GET.
class Path {
  final String path;
  final String method;
  const Path(this.path, {this.method = 'GET'});

  @override
  String toString() {
    return 'Path(path: $path, method: $method)';
  }
}

/// Param annotation for specifying a parameter in a controller.
///
/// Example:
/// ```dart
/// class MyController extends Controller {
/// @Path('/hello/:name', 'GET')
/// void hello(HttpRequest request) {
///  final name = request.params['name'];
/// Response.ok(request, 'Hello $name!');
/// }
/// ```
class Param {
  final List<String> params;
  const Param(this.params);

  @override
  String toString() {
    return 'Param(params: $params)';
  }
}
