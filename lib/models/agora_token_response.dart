import 'dart:convert';

class AgoraTokenResponse {
  final String chanelName;
  final String token;
  
  AgoraTokenResponse({
    required this.chanelName,
    required this.token,
  });
  AgoraTokenResponse copyWith({
    String? chanelName,
    String? token,
  }) {
    return AgoraTokenResponse(
      chanelName: chanelName ?? this.chanelName,
      token: token ?? this.token,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'chanelName': chanelName,
      'token': token,
    };
  }
  factory AgoraTokenResponse.fromMap(Map<String, dynamic> map) {
    return AgoraTokenResponse(
      chanelName: map['chanelName'],
      token: map['token'],
    );
  }
  String toJson() => json.encode(toMap());
  factory AgoraTokenResponse.fromJson(String source) => AgoraTokenResponse.fromMap(json.decode(source));
  @override
  String toString() => 'AgoraTokenResponse(chanelName: $chanelName, token: $token)';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AgoraTokenResponse &&
      other.chanelName == chanelName &&
      other.token == token;
  }
  @override
  int get hashCode => chanelName.hashCode ^ token.hashCode;
}
