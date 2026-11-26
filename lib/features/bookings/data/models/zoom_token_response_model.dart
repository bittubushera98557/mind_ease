/// Response model for Zoom Video Token API GET /me/bookings/{bookingId}/video-token
class ZoomTokenResponseModel {
  final String token;
  final String sessionName;
  final String role;
  final String? expiresAt;
  final List<dynamic> userIdentity;

  const ZoomTokenResponseModel({
    required this.token,
    required this.sessionName,
    required this.role,
    this.expiresAt,
    this.userIdentity = const [],
  });

  factory ZoomTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return ZoomTokenResponseModel(
      token: json['token'] as String? ?? '',
      sessionName: json['sessionName'] as String? ?? '',
      role: json['role'] as String? ?? 'host',
      expiresAt: json['expiresAt'] as String?,
      userIdentity: json['userIdentity'] as List<dynamic>? ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'sessionName': sessionName,
      'role': role,
      'expiresAt': expiresAt,
      'userIdentity': userIdentity,
    };
  }
}
