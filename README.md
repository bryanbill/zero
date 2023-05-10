# Zero

Zero is a fast and lightweight **Dart** backend framework.

## Installation

Activate the Zero CLI tool:

```bash
dart pub global activate --source git https://github.com/bryanbill/zero
# Or using -sgit
dart pub global activate -sgit https://github.com/bryanbill/zero
```

Create a new project:

```bash
zero new my_project
```

## Usage

Run the project:

```bash
cd my_project
zero run
```

## Examples

### Hello World

```dart
import 'package:zero/zero.dart';

void main() {
  final zero = Server(
    port: 9090,
    routes: [
      Route(
        path: '/hello',
        controller: (req) => IndexController(req),
      ),
     
    ],
  );

  zero.run();

  print('Server running on port ${zero.port}');
}

class IndexController extends Controller {
  IndexController(Request request) : super(request);

  @Path('/')
  static Response hello(Request request) {
    return Response.ok('Hello world!');
  }
}
```

### Working with Routes, Params, Body and Query

```dart
import 'package:zero/zero.dart';

class UserController extends Controller {
  UserController(Request request) : super(request);

  // GET => /users
  @Path('/')
  static Future<Response> user(Request req) async{
    await Future.delayed(Duration(seconds: 1));
    return Response.ok('User');
  }

  // GET => /users/:id
  @Path('/:id')
  @Param(['id'])
  static Future<Response> userById(Request req) async{
    await Future.delayed(Duration(seconds: 1));
    return Response.ok('User ${req.params['id']}');
  }

  // POST => /users
  @Path('/', method: 'POST')
  static Future<Response> createUser(Request req) async{
    await Future.delayed(Duration(seconds: 1));
    return Response.created('User created');
  }
}

void main(){
    final zero = Server(
        port: 9090,
        routes: [
        Route(
            path: '/users',
            controller: (req) => UserController(req),
        ),
        ],
    );
    
    zero.run();
    
    print('Server running on port ${zero.port}');
}

```



## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you have a way to improve this project.

## License

[MIT](https://choosealicense.com/licenses/mit/)
