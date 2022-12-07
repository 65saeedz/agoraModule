// To parse this JSON data, do
//
//     final CancelCallQuery = CancelCallQueryFromJson(jsonString);

import 'dart:convert';

CancelCallQuery CancelCallQueryFromJson(String str) =>
    CancelCallQuery.fromJson(json.decode(str));

String CancelCallQueryToJson(CancelCallQuery data) =>
    json.encode(data.toJson());

class CancelCallQuery {
  CancelCallQuery({
    required this.token,
    required this.callId,
  });

  String token;
  String callId;

  factory CancelCallQuery.fromJson(Map<String, dynamic> json) =>
      CancelCallQuery(
        token: json["token"],
        callId: json["call_id"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "call_id": callId,
      };
}
