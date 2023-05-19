import 'dart:async';

import 'package:zero/models/request.dart';
import 'package:zero/models/response.dart';

abstract class Middleware {
  const Middleware();
  FutureOr<RequestOrResponse> handle(Request request);
}

class RequestOrResponse {
  final Request? request;
  final Response? response;

  RequestOrResponse({this.request, this.response});
}
