/// Top-level response model for /programs API
class ProgramResponseModel {
  final List<ProgramItemModel> programs;
  final ApiErrorModel? error;

  const ProgramResponseModel({
    this.programs = const [],
    this.error,
  });

  /// Returns true if API call succeeded
  bool get isSuccess => error == null;

  factory ProgramResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic> &&
        json.containsKey('error') &&
        json['error'] is Map<String, dynamic>) {
      return ProgramResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    List<ProgramItemModel> items = [];
    if (json is List) {
      items = json
          .whereType<Map<String, dynamic>>()
          .map((item) => ProgramItemModel.fromJson(item))
          .toList();
    } else if (json is Map<String, dynamic>) {
      final listData = json['programs'] ?? json['data'];
      if (listData is List) {
        items = listData
            .whereType<Map<String, dynamic>>()
            .map((item) => ProgramItemModel.fromJson(item))
            .toList();
      }
    }

    return ProgramResponseModel(programs: items);
  }

  dynamic toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return programs.map((p) => p.toJson()).toList();
  }

  ProgramResponseModel copyWith({
    List<ProgramItemModel>? programs,
    ApiErrorModel? error,
  }) {
    return ProgramResponseModel(
      programs: programs ?? this.programs,
      error: error ?? this.error,
    );
  }
}

/// Model representing an individual program item
class ProgramItemModel {
  final String id;
  final String title;
  final String short;
  final String status;
  final int displayOrder;
  final String? coverImage;

  const ProgramItemModel({
    this.id = '',
    this.title = '',
    this.short = '',
    this.status = '',
    this.displayOrder = 0,
    this.coverImage,
  });

  factory ProgramItemModel.fromJson(Map<String, dynamic> json) {
    return ProgramItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      short: json['short']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      displayOrder: _parseInt(json['displayOrder']),
      coverImage: json['coverImage']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'short': short,
      'status': status,
      'displayOrder': displayOrder,
      if (coverImage != null) 'coverImage': coverImage,
    };
  }

  ProgramItemModel copyWith({
    String? id,
    String? title,
    String? short,
    String? status,
    int? displayOrder,
    String? coverImage,
  }) {
    return ProgramItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      short: short ?? this.short,
      status: status ?? this.status,
      displayOrder: displayOrder ?? this.displayOrder,
      coverImage: coverImage ?? this.coverImage,
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
      'field': field,
    };
  }
}
