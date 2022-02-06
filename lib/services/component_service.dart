import 'dart:convert';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class ComponentService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> getBikeComponents(String bikeId) async {
    Response response =
        await client.get(Uri.parse('$endpoint/bikes/$bikeId/components'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getComponentsAlerts(String memberId) async {
    Response response = await client
        .get(Uri.parse('$endpoint/members/$memberId/components/alerts'));
    return HttpResponse(response);
  }

  Future<HttpResponse> changeComponent(
      String componentId, DateTime date) async {
    Response response = await client.patch(
        Uri.parse('$endpoint/components/$componentId'),
        body: jsonEncode(<String, dynamic>{'changedAt': date.toString()}));
    return HttpResponse(response);
  }
}
