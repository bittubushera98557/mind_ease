/// Response model for Zoom Video Token API POST /me/bookings/{bookingId}/video-token
class ZoomTokenResponseModel {
  final String token;
  final String sessionName;
  final String role;
  final String? expiresAt;
  final String userIdentity;

  const ZoomTokenResponseModel({
    required this.token,
    required this.sessionName,
    required this.role,
    this.expiresAt,
    this.userIdentity = '',
  });

  factory ZoomTokenResponseModel.fromJson(Map<String, dynamic> json) {
    String identityStr = '';
    final rawIdentity = json['userIdentity'];
    if (rawIdentity is String) {
      identityStr = rawIdentity;
    } else if (rawIdentity is List && rawIdentity.isNotEmpty) {
      identityStr = rawIdentity.first.toString();
    } else if (rawIdentity != null) {
      identityStr = rawIdentity.toString();
    }

    return ZoomTokenResponseModel(
      token: json['token'] as String? ?? '',
      sessionName: json['sessionName'] as String? ?? '',
      role: json['role'] as String? ?? 'participant',
      expiresAt: json['expiresAt'] as String?,
      userIdentity: identityStr,
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
