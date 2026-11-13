/// Top-level response model for /therapists API endpoint
class TherapistsListResp {
  final List<TherapistModel> therapists;
  final ApiErrorModel? error;

  const TherapistsListResp({
    this.therapists = const [],
    this.error,
  });

  /// Returns true if the API request succeeded without error
  bool get isSuccess => error == null;

  factory TherapistsListResp.fromJson(dynamic json) {
    if (json is Map<String, dynamic> &&
        json.containsKey('error') &&
        json['error'] is Map<String, dynamic>) {
      return TherapistsListResp(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    List<TherapistModel> items = [];
    if (json is List) {
      items = json
          .whereType<Map<String, dynamic>>()
          .map((item) => TherapistModel.fromJson(item))
          .toList();
    } else if (json is Map<String, dynamic>) {
      final listData = json['therapists'] ?? json['data'];
      if (listData is List) {
        items = listData
            .whereType<Map<String, dynamic>>()
            .map((item) => TherapistModel.fromJson(item))
            .toList();
      }
    }

    return TherapistsListResp(therapists: items);
  }

  dynamic toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return therapists.map((t) => t.toJson()).toList();
  }

  TherapistsListResp copyWith({
    List<TherapistModel>? therapists,
    ApiErrorModel? error,
  }) {
    return TherapistsListResp(
      therapists: therapists ?? this.therapists,
      error: error ?? this.error,
    );
  }
}

/// Cleans focus area or specialty label if it is a raw map or key-label string
String cleanFocusLabel(dynamic item) {
  if (item == null) return '';
  if (item is Map) {
    final label = item['label'] ?? item['name'] ?? item['title'] ?? item['key'];
    if (label != null && label.toString().isNotEmpty) {
      return label.toString().trim();
    }
    return item.toString();
  }
  final str = item.toString().trim();
  if (str.isEmpty) return '';

  // Extract label if pattern match like "label: ..."
  final labelMatch =
      RegExp(r'label:\s*([^,\}\]]+)', caseSensitive: false).firstMatch(str);
  if (labelMatch != null) {
    final extracted = labelMatch.group(1)?.trim() ?? str;
    return extracted.replaceAll('"', '').replaceAll("'", '').trim();
  }

  // Extract key if pattern match like "key: ..."
  final keyMatch =
      RegExp(r'key:\s*([^,\}\]]+)', caseSensitive: false).firstMatch(str);
  if (keyMatch != null) {
    final extracted = keyMatch.group(1)?.trim() ?? str;
    return extracted.replaceAll('"', '').replaceAll("'", '').trim();
  }

  return str;
}

/// Model representing a single Therapist item from /therapists
class TherapistModel {
  final String id;
  final String name;
  final String? bio;
  final List<String> specialties;
  final String? photoUrl;
  final String? timezone;
  final int priceCents;
  final String currency;
  final int sessionMinutes;

  const TherapistModel({
    this.id = '',
    this.name = '',
    this.bio,
    this.specialties = const [],
    this.photoUrl,
    this.timezone,
    this.priceCents = 0,
    this.currency = 'aud',
    this.sessionMinutes = 50,
  });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    List<String> specs = [];
    final rawSpecs = json['specialties'] ?? json['focus'] ?? json['focusAreas'];
    if (rawSpecs is List) {
      specs = rawSpecs
          .map((e) => cleanFocusLabel(e))
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return TherapistModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bio: json['bio']?.toString(),
      specialties: specs,
      photoUrl: json['photoUrl']?.toString(),
      timezone: json['timezone']?.toString(),
      priceCents: _parseInt(json['priceCents']),
      currency: json['currency']?.toString() ?? 'aud',
      sessionMinutes: _parseInt(json['sessionMinutes'], defaultValue: 50),
    );
  }

  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (bio != null) 'bio': bio,
      'specialties': specialties,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (timezone != null) 'timezone': timezone,
      'priceCents': priceCents,
      'currency': currency,
      'sessionMinutes': sessionMinutes,
    };
  }

  /// Formatted price string (e.g., "$150")
  String get formattedPrice {
    if (priceCents <= 0) return r'$0';
    final dollars = priceCents / 100.0;
    if (dollars % 1 == 0) {
      return '\$${dollars.toInt()}';
    }
    return '\$${dollars.toStringAsFixed(2)}';
  }

  /// Gets therapist initials from name (e.g., "Dr Paras" -> "DP")
  String get initials {
    if (name.isEmpty) return 'T';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  TherapistModel copyWith({
    String? id,
    String? name,
    String? bio,
    List<String>? specialties,
    String? photoUrl,
    String? timezone,
    int? priceCents,
    String? currency,
    int? sessionMinutes,
  }) {
    return TherapistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      specialties: specialties ?? this.specialties,
      photoUrl: photoUrl ?? this.photoUrl,
      timezone: timezone ?? this.timezone,
      priceCents: priceCents ?? this.priceCents,
      currency: currency ?? this.currency,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    );
  }
}

/// Model representing API error response
class ApiErrorModel {
  final String code;
  final String message;
  final String? field;

  const ApiErrorModel({
    required this.code,
    required this.message,
    this.field,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      field: json['field']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      if (field != null) 'field': field,
    };
  }
}
