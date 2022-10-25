import 'package:agora15min/models/agora_token_query.dart';
import 'package:agora15min/models/agora_token_response.dart';
import 'package:dio/dio.dart';

class HttpClient {
  late Dio dio;

  HttpClient() {
    dio = Dio(
      BaseOptions(baseUrl: 'http://65.21.119.84:2021'),
    );
  }

  Future<AgoraTokenResponse> fetchAgoraToken(AgoraTokenQuery query) async {
    final dioResponse = await dio.get(
      '/join_user_to_agora',
      queryParameters: query.toMap(),
    );

    final agoraTokenResponseList =
        (dioResponse.data as List).first as Map<String, dynamic>;
    final agoraTokenResponse =
        AgoraTokenResponse.fromMap(agoraTokenResponseList);

    return agoraTokenResponse;
  }
}
