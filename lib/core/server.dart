import 'dart:io';

import 'package:zero/models/route.dart';
import 'package:zero/models/request.dart';

/// Server class for running a server.
///
/// Example:
/// ```dart
/// final server = Server(
///                   port: 8080,
///                   routes: [
///                             Route(
///                               path: '/hello',
///                               controller: (req) => IndexController(req)
///                             )
///                           ]
///                 );
///
/// server.run();
/// ```
class Server {
  final int? port;
  final String? host;
  final List<Route> routes;

  late HttpServer _server;

  HttpServer get server => _server;

  Server({this.port = 8080, this.host, required this.routes});

  void run() async {
    _server = await HttpServer.bind(host ?? InternetAddress.anyIPv4, port!);
    _server.listen(
      (request) {
        final path = request.uri.path.split('/');

        final route = routes.firstWhere(
          (route) => route.path == '/${path[1]}',
          orElse: () => routes.firstWhere(
            (route) => route.path == '/404',
            orElse: () => throw ArgumentError('No 404 route found'),
          ),
        );
        route.controller(Request.fromHttpRequest(request)).exec();
      },
    );
  }

  Future<void> stop(HttpServer server) async {
    await server.close(force: true);
  }
}
