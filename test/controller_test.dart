import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:zero/models/request.dart';

import 'controller/test_controller.dart';

void main() {
  late HttpRequest request;
  late HttpServer testServer;
  late TestController testController;

  setUp(() async => await HttpServer.bind("localhost", 8080).then(
        (server) => server.listen((event) {
          testServer = server;
          request = event;
          testController = TestController(Request.fromHttpRequest(request));
        }),
      ));

  group("Controller:", () {
    test("Path: '/hello' returns 'Hello World'", () async {
      // make a request to the server
      final client = HttpClient();
      final response =
          await (await client.get("localhost", 8080, "/hello")).close();

      response.transform(utf8.decoder).listen((contents) {
        expect(contents, "Hello World!");
      });
    });

    test("Request should not be null", () {
      expect(testController.request, isNotNull);
    });
  });

  tearDown(() async => await testServer.close(force: true));
}
