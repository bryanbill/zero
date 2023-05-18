import 'dart:async';
import 'dart:convert';
import 'dart:mirrors';

import 'package:zero/zero.dart';

/// Controller class for handling API requests.
///
/// This class is used to handle API requests. It is used by the [Route] class
/// to route requests to the appropriate controller and method.
///
/// The [Controller] class is an abstract class, and should not be used
/// directly. Instead, create a subclass of [Controller] and annotate it
/// with the [Path] annotation. The [Path] annotation is used to specify the
/// path that the controller will handle, as well as the HTTP method that the
/// controller will handle.
///
/// The [Controller] class will automatically handle requests to the
/// appropriate controller and method. The [Controller] class will also
/// automatically handle requests to non-existent controllers and methods by
/// returning a 404 response.
///
/// Example:
/// ```dart
/// class MyController extends Controller {
///  @Path('/hello', 'GET')
/// static void hello(HttpRequest request) {
///   Response.ok(request, 'Hello World!');
/// }
/// ```
///
/// NOTE: The methods should be static.

abstract class Controller {
  static final _classMirrorCache = <Type, ClassMirror>{};
  final Request request;

  ClassMirror? _classMirror;
  MethodMirror? _methodMirror;
  List<dynamic>? _positionalArgs;

  Controller(this.request) {
    final classType = runtimeType;
    var classMirror = _classMirrorCache[classType];

    if (classMirror == null) {
      classMirror = reflectClass(classType);
      _classMirrorCache[classType] = classMirror;
    }

    final methodMirrors =
        classMirror.declarations.values.whereType<MethodMirror>().toList();
    final pathMethodMap = <String, Map<String, MethodMirror>>{};

    for (final methodMirror in methodMirrors) {
      final metadata = methodMirror.metadata
          .where((metadataMirror) => metadataMirror.reflectee is Path)
          .map((metadataMirror) => metadataMirror.reflectee as Path);

      if (metadata.length != 1) {
        continue;
      }

      final path = metadata.first.path;
      final method = metadata.first.method.toUpperCase();
      final methodMap =
          pathMethodMap.putIfAbsent(path, () => <String, MethodMirror>{});

      if (methodMap.containsKey(method)) {
        throw ArgumentError('Duplicate path and method: $path $method');
      }

      methodMap[method] = methodMirror;
    }

    var path = '/${request.url?.split('/').skip(2).join('/')}';

    final method = request.method?.toUpperCase();
    var methodMap = pathMethodMap[path];

    if (methodMap == null) {
      final paramMetaData = classMirror.declarations.values
          .whereType<MethodMirror>()
          .where((methodMirror) => methodMirror.metadata
              .where((metadataMirror) => metadataMirror.reflectee is Param)
              .isNotEmpty)
          .map((methodMirror) => methodMirror.metadata
              .where((metadataMirror) => metadataMirror.reflectee is Param)
              .first
              .reflectee as Param);

      for (var route in pathMethodMap.keys) {
        final params = paramMetaData.first.params;
        final pathParts = route.split('/')
          ..removeWhere((element) => element.isEmpty);
        final requestPathParts = path.split('/')
          ..removeWhere((element) => element.isEmpty);

        if (pathParts.length != requestPathParts.length) {
          continue;
        }

        final pathParams = <String, String>{};

        for (var i = 0; i < pathParts.length; i++) {
          final pathPart = pathParts[i];
          final requestPathPart = requestPathParts[i];

          if (pathPart.startsWith(':')) {
            pathParams[pathPart.substring(1)] = requestPathPart;
          } else if (pathPart != requestPathPart) {
            break;
          }
        }

        if (pathParams.length == params.length) {
          request.params = pathParams;
          methodMap = pathMethodMap[route];
          break;
        }
      }
    }

    _positionalArgs = [request];

    _methodMirror = methodMap?[method];

    _classMirror = classMirror;

    return;
  }

  /// Executes the controller method.
  ///
  /// This method is called by the [Route] class to execute the controller
  /// method.
  ///
  /// This method will throw an [Exception] if the controller method is not found.

  Future<void> exec() async {
    try {
      if (_classMirror == null || _methodMirror == null) {
        throw Exception(
          'Controller: ${request.method} => ${request.url}  not found. See Exception (https://zero.namani.co/docs/exceptions#err-1) for more details.',
        ); // Err-1
      }

      final splitDecoded = StreamTransformer<List<int>, String>.fromBind(
          (stream) => stream.transform(utf8.decoder).transform(LineSplitter()));

      request.body = jsonDecode(await request.app!
          .transform(StreamTransformer.castFrom(splitDecoded))
          .join()) as Map<String, dynamic>;

      final instanceMirror = _classMirror?.invoke(
        _methodMirror!.simpleName,
        _positionalArgs ?? [],
      );

      if (instanceMirror != null) {
        final response = await instanceMirror.reflectee as Response;
        response.send(request.app!);
        return;
      }
      throw Exception(
        'Controller: ${request.method} => ${request.url}  not found. See Exception (https://zero.namani.co/docs/exceptions#err-1) for more details.',
      ); // Err-1
    } catch (e) {
      print(e);
      print(StackTrace.current);
      Response.notFound().send(request.app!);
    }
  }
}

// Err-1: Throw Exception if classMirror or methodMirror is null, possibly due to
// a missing Path annotation on the class or method or a wrong route path.
