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

  print('Listening on port ${zero.port}');
}

class IndexController extends Controller {
  IndexController(Request request) : super(request);

  @Path('/')
  Response hello() {
    return Response.ok('Hello world!');
  }
}
