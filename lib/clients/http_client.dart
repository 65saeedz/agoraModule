import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

import '/models/accept_call_query.dart';
import '/models/cancel_call_query.dart';
import '/models/agora_token_query.dart';
import '/models/agora_token_response.dart';

class HttpClient {
  final _baseUrl = 'http://65.21.119.84:2021';

  late Dio _dio;

  HttpClient() {
    _dio = Dio(
      BaseOptions(baseUrl: _baseUrl),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(maxWidth: 180, responseBody: true, request: true),
      );
    }
  }

  Future<AgoraTokenResponse> fetchAgoraToken(AgoraTokenQuery query) async {
    final dioResponse = await _dio.get(
      '/join_user_to_agora',
      queryParameters: query.toMap(),
    );

    final agoraTokenResponseList =
        (dioResponse.data as List).first as Map<String, dynamic>;
    final agoraTokenResponse =
        AgoraTokenResponse.fromMap(agoraTokenResponseList);
    return agoraTokenResponse;
  }

  Future<bool> setCallingStatus(AcceptCallQuery query) async {
    try {
      await _dio.get(
        '/calling',
        queryParameters: query.toJson(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }


    Future<bool> cancelCallingStatus(CancelCallQuery query) async {
    try {
      await _dio.get(
        '/cancel_call',
        queryParameters: query.toJson(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
