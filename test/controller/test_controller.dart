import 'package:zero/zero.dart';

class TestController extends Controller {
  TestController(Request request) : super(request);

  @Path('/hello', method: 'GET')
  static Response hello(Request request) {
    return Response.ok('Hello World!');
  }
}
