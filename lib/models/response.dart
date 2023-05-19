import 'dart:convert';
import 'dart:io';

/// A class that represents a response to an HTTP request.
///
/// Example:
/// ```dart
/// Response.ok({'message': 'Hello World!'});
/// ```
///
/// This will return a response with a status code of 200 and a body of
/// `{'message': 'Hello World!'}`.
///
/// You can also specify headers and cookies:
/// ```dart
/// Response.ok(
///  {'message': 'Hello World!'},
/// headers: {'Content-Type': 'application/json'},
/// cookies: [Cookie('name', 'value')],
/// );
/// ```
///
/// This will return a response with a status code of 200, a body of
/// `{'message': 'Hello World!'}`, a header of `{'Content-Type': 'application/json'}`,
/// and a cookie of `Cookie('name', 'value')`.

class Response {
  final int statusCode;
  final Object? body;
  final Map<String, String>? headers;
  final List<Cookie>? cookies;

  Response({
    this.statusCode = 200,
    this.body,
    this.headers,
    this.cookies = const [],
  });

  /// Returns a Response with a status code of 200.
  factory Response.ok([Object? body, Map<String, String>? headers]) => Response(
        statusCode: 200,
        body: body ?? {},
        headers: headers ??
            {
              'Content-Type': 'application/json',
            },
      );

  /// Returns a Response with a status code of 201.
  factory Response.created([Object? body, Map<String, String>? headers]) =>
      Response(statusCode: 201, body: body ?? {}, headers: headers ?? {
        'Content-Type': 'application/json',
      });

  /// Returns a Response with a status code of 400.
  factory Response.badRequest([Object? body, Map<String, String>? headers]) =>
      Response(
          statusCode: 400,
          body: body ?? {'message': 'Bad Request'},
          headers: headers ?? {'Content-Type': 'application/json'});

  /// Returns a Response with a status code of 401.
  factory Response.unauthorized([Object? body, Map<String, String>? headers]) =>
      Response(
          statusCode: 401,
          body: body ?? {'message': 'Unauthorized'},
          headers: headers ?? {'Content-Type': 'application/json'});

  /// Returns a Response with a status code of 404.
  factory Response.notFound([Object? body, Map<String, String>? headers]) =>
      Response(
          statusCode: 404,
          body: body ?? {'message': 'Not Found'},
          headers: headers ?? {'Content-Type': 'application/json'});

  /// Returns a Response with a status code of 500.
  factory Response.internalServerError(
          [Object? body, Map<String, String>? headers]) =>
      Response(
          statusCode: 500,
          body: body ?? {'message': 'Internal Server Error'},
          headers: headers ?? {'Content-Type': 'application/json'});

  /// Returns a Response with a status code of 302.
  factory Response.redirect(String location) => Response(
        statusCode: 302,
        headers: {'Location': location},
      );

  /// Returns a Response with a status code of 403.
  factory Response.forbidden([Object? body, Map<String, String>? headers]) =>
      Response(
          statusCode: 403,
          body: body ?? {'message': 'Forbidden'},
          headers: headers ?? {'Content-Type': 'application/json'});

  /// Sends the response to the client.
  void send(HttpRequest request) {
    headers?.forEach((key, value) {
      request.response.headers.add(key, value);
    });

    final data = headers?['Content-Type'] == 'application/json'
        ? jsonEncode(body)
        : body;

    request.response
      ..statusCode = statusCode
      ..cookies.addAll(cookies ?? [])
      ..write(data)
      ..close();
  }
}
