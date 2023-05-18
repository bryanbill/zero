/// Describes the structure of the [Request] body
///
/// Example:
/// ```dart
/// @Body([
///  Field('name', type: String, isRequired: true),
/// Field('age', type: int, isRequired: true),
/// Field('email', type: String, isRequired: true, pattern: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
/// ])
/// ```
class Body {
  final List<Field> fields;

  const Body(this.fields);

  @override
  String toString() { 
    return 'Body{field: $fields}';
  }
}

/// Describes the field properties of the [Body]
///
/// Example:
/// ```dart
/// Field('name', type: String, isRequired: true)
/// ```
///
/// * [name] is the name of the field
/// * [type] is the type of the field
/// * [isRequired] is the field required or not
/// * [pattern] is the regex pattern to validate the field
class Field {
  final String name;
  final Type? type;
  final bool? isRequired;
  final String? pattern;

  const Field(this.name, {this.type, this.isRequired, this.pattern});

  @override
  String toString() {
    return 'Field{name: $name, type: $type}';
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
