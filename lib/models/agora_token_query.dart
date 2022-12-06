import 'dart:convert';

class AgoraTokenQuery {
  final String token;
  final String? chanelName;
  final int? caller_id;
  final int pree_id;
  final int? has_video;

  AgoraTokenQuery({
    required this.token,
    this.chanelName,
    this.caller_id,
    required this.pree_id,
    this.has_video,
  });

  AgoraTokenQuery copyWith({
    String? token,
    String? chanelName,
    int? caller_id,
    int? pree_id,
    int? has_video,
  }) {
    return AgoraTokenQuery(
      token: token ?? this.token,
      chanelName: chanelName ?? this.chanelName,
      caller_id: caller_id ?? this.caller_id,
      pree_id: pree_id ?? this.pree_id,
      has_video: has_video ?? this.has_video,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'chanelName': chanelName,
      'caller_id': caller_id,
      'pree_id': pree_id,
      'has_video': has_video,
    };
  }

  factory AgoraTokenQuery.fromMap(Map<String, dynamic> map) {
    return AgoraTokenQuery(
      token: map['token'],
      chanelName: map['chanelName'],
      caller_id: map['caller_id'],
      pree_id: map['pree_id'],
      has_video: map['has_video'],
    );
  }

  String toJson() => json.encode(toMap());
  factory AgoraTokenQuery.fromJson(String source) => AgoraTokenQuery.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AgoraTokenQuery(token: $token, chanelName: $chanelName, caller_id: $caller_id, pree_id: $pree_id, has_video: $has_video)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AgoraTokenQuery &&
      other.token == token &&
      other.chanelName == chanelName &&
      other.caller_id == caller_id &&
      other.pree_id == pree_id &&
      other.has_video == has_video;
  }
  
  @override
  int get hashCode {
    return token.hashCode ^
      chanelName.hashCode ^
      caller_id.hashCode ^
      pree_id.hashCode ^
      has_video.hashCode;
  }
}
