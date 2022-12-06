// To parse this JSON data, do
//
//     final acceptCallQuery = acceptCallQueryFromJson(jsonString);

import 'dart:convert';

AcceptCallQuery acceptCallQueryFromJson(String str) =>
    AcceptCallQuery.fromJson(json.decode(str));

String acceptCallQueryToJson(AcceptCallQuery data) =>
    json.encode(data.toJson());

class AcceptCallQuery {
  AcceptCallQuery({
    required this.token,
    required this.callId,
  });

  String token;
  String callId;

  factory AcceptCallQuery.fromJson(Map<String, dynamic> json) =>
      AcceptCallQuery(
        token: json["token"],
        callId: json["call_id"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "call_id": callId,
      };
}
