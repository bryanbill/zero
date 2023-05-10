import 'dart:io';

/// Request
///
/// This class contains data from the [HttpRequest].
///
class Request {
  /// The original [HttpRequest] object.
  final HttpRequest? app;

  // The URL path in which the route was registered.
  final String? baseUrl;

  /// Contains data from the request body.
  ///
  /// Empty by default.
  Map<String, dynamic>? body;

  /// Contains cookies sent by the request.
  final List<Cookie?> cookies;

  /// Contains the hostname derived from the Host HTTP header.
  final String? hostname;

  /// Remote IP address of the request.
  final String? ip;

  /// Contains the request method.
  ///
  /// Example: GET, POST, PUT, DELETE, etc.
  final String? method;

  /// Contains the original URL of the request.
  final String? originalUrl;

  /// Contains the request parameters.
  Map<String, dynamic>? params;

  /// Contains the request protocol.
  ///
  /// Example: http, https, etc.
  final String? protocol;

  /// Contains the request query string parameters.
  Map<String, dynamic>? query;

  /// Contains the request route.
  final String? route;

  /// Contains the request subdomains.
  final List<String>? subdomains;

  /// Contains the request URL.
  final String? url;

  Request({
    this.app,
    this.baseUrl,
    this.body,
    this.cookies = const [],
    this.hostname,
    this.ip,
    this.method,
    this.originalUrl,
    this.protocol,
    this.route,
    this.subdomains,
    this.url,
  });

  /// Returns a Request object from an [HttpRequest].
  ///
  /// Example:
  /// ```dart
  /// Request.fromHttpRequest(request);
  /// ```
  factory Request.fromHttpRequest(HttpRequest request) {
    return Request(
      app: request,
      baseUrl: request.uri.toString(),
      cookies: request.cookies,
      hostname: request.uri.host,
      ip: request.connectionInfo?.remoteAddress.address,
      method: request.method,
      originalUrl: request.uri.toString(),
      protocol: request.uri.scheme,
      route: request.uri.path,
      subdomains: request.uri.host.split('.'),
      url: request.uri.path.toString(),
    );
  }

  @override
  String toString() {
    return 'Request(app: $app, baseUrl: $baseUrl, body: $body, cookies: $cookies, hostname: $hostname, ip: $ip, method: $method, originalUrl: $originalUrl, params: $params, protocol: $protocol, query: $query, route: $route, subdomains: $subdomains, url: $url)';
  }
}
