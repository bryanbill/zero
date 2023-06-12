/// Zero library.
///
/// This library contains all the core classes of the Zero framework.
///
/// Example:
/// ```dart
/// void  main() {
///   final zero = Server(
///    port: 8080,
///    routes: [
///     Route(),
///   ],
///
///   zero.run();
/// );
/// ```
library zero;

export 'package:zero/core/server.dart';
export 'package:zero/models/route.dart';
export 'package:zero/core/controller.dart';
export 'package:zero/core/middleware.dart';
export 'package:zero/core/storage.dart';

export 'package:zero/models/response.dart';
export 'package:zero/models/request.dart';
export 'package:zero/models/annotations.dart';

export 'package:zero/utils/meta.dart';


