import 'dart:convert';

class AgoraTokenResponse {
  final String chanelName;
  final String token;
  final String call_id;

  AgoraTokenResponse({
    required this.chanelName,
    required this.token,
    required this.call_id,
  });
  AgoraTokenResponse copyWith({
    String? chanelName,
    String? token,
    String? call_id,
  }) {
    return AgoraTokenResponse(
      chanelName: chanelName ?? this.chanelName,
      token: token ?? this.token,
      call_id: call_id ?? this.call_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chanelName': chanelName,
      'token': token,
      'call_id': call_id,
    };
  }

  factory AgoraTokenResponse.fromMap(Map<String, dynamic> map) {
    return AgoraTokenResponse(
      chanelName: map['chanelName'],
      token: map['token'],
      call_id: map['call_id'].toString(),
    );
  }
  String toJson() => json.encode(toMap());
  factory AgoraTokenResponse.fromJson(String source) =>
      AgoraTokenResponse.fromMap(json.decode(source));
  @override
  String toString() =>
      'AgoraTokenResponse(chanelName: $chanelName, token: $token, call_id:$call_id,)';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AgoraTokenResponse &&
        other.chanelName == chanelName &&
        other.call_id == call_id &&
        other.token == token;
  }

  @override
  int get hashCode => chanelName.hashCode ^ token.hashCode ^ call_id.hashCode;
}
