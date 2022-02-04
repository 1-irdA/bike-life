import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class TipService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<Response> getAll() async {
    return await client.get(Uri.parse('$endpoint/tips'));
  }

  Future<Response> getByTopic(String topic) async {
    return await client.get(Uri.parse('$endpoint/topics/$topic/tips'));
  }
}
