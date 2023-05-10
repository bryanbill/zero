import 'package:test/test.dart';
import 'package:zero/core/server.dart';
import 'package:zero/models/route.dart';

import 'controller/test_controller.dart';

void main() {
  late Server zero;

  setUp(() {
    zero = Server(
      port: 8080,
      routes: [
        Route(
          path: '/hello',
          controller: (request) => TestController(request)..exec(),
        ),
      ],
    );

    zero.run();
  });

  group("Server:", () {
    test("Running on specified port : 8080", () {
      expect(zero.port, 8080);
    });

    test('Initialization -  Server should not be null', () {
      expect(zero.server, isNotNull);
    });
  });

  tearDown(() {
    zero.stop(zero.server);
  });
}
