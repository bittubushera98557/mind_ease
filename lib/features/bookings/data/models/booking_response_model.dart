/// Top-level response model for me/bookings API endpoint
class BookingResponseModel {
  final List<BookingItemModel> bookings;
  final ApiErrorModel? error;

  const BookingResponseModel({
    this.bookings = const [],
    this.error,
  });

  /// Returns true if the API request succeeded without error
  bool get isSuccess => error == null;

  factory BookingResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic> &&
        json.containsKey('error') &&
        json['error'] is Map<String, dynamic>) {
      return BookingResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    List<BookingItemModel> items = [];
    if (json is List) {
      items = json
          .whereType<Map<String, dynamic>>()
          .map((item) => BookingItemModel.fromJson(item))
          .toList();
    } else if (json is Map<String, dynamic>) {
      final listData = json['bookings'] ?? json['data'];
      if (listData is List) {
        items = listData
            .whereType<Map<String, dynamic>>()
            .map((item) => BookingItemModel.fromJson(item))
            .toList();
      }
    }

    return BookingResponseModel(bookings: items);
  }

  dynamic toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return bookings.map((b) => b.toJson()).toList();
  }

  BookingResponseModel copyWith({
    List<BookingItemModel>? bookings,
    ApiErrorModel? error,
  }) {
    return BookingResponseModel(
      bookings: bookings ?? this.bookings,
      error: error ?? this.error,
    );
  }
}

/// Model representing a single booking item
class BookingItemModel {
  final String id;
  final String status;
  final String? cancelReason;
  final String? startsAt;
  final String? endsAt;
  final String? holdExpiresAt;
  final BookingTherapistModel? therapist;
  final int priceCents;
  final String currency;
  final String? notes;
  final BookingPaymentModel? payment;
  final bool canCancel;
  final int refundIfCancelledCents;
  final String? joinOpensAt;
  final String? createdAt;

  const BookingItemModel({
    this.id = '',
    this.status = '',
    this.cancelReason,
    this.startsAt,
    this.endsAt,
    this.holdExpiresAt,
    this.therapist,
    this.priceCents = 0,
    this.currency = '',
    this.notes,
    this.payment,
    this.canCancel = false,
    this.refundIfCancelledCents = 0,
    this.joinOpensAt,
    this.createdAt,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json) {
    return BookingItemModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      cancelReason: json['cancelReason']?.toString(),
      startsAt: json['startsAt']?.toString(),
      endsAt: json['endsAt']?.toString(),
      holdExpiresAt: json['holdExpiresAt']?.toString(),
      therapist: json['therapist'] is Map<String, dynamic>
          ? BookingTherapistModel.fromJson(
              json['therapist'] as Map<String, dynamic>)
          : null,
      priceCents: _parseInt(json['priceCents']),
      currency: json['currency']?.toString() ?? '',
      notes: json['notes']?.toString(),
      payment: json['payment'] is Map<String, dynamic>
          ? BookingPaymentModel.fromJson(
              json['payment'] as Map<String, dynamic>)
          : null,
      canCancel: json['canCancel'] == true,
      refundIfCancelledCents: _parseInt(json['refundIfCancelledCents']),
      joinOpensAt: json['joinOpensAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
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
      'status': status,
      if (cancelReason != null) 'cancelReason': cancelReason,
      if (startsAt != null) 'startsAt': startsAt,
      if (endsAt != null) 'endsAt': endsAt,
      if (holdExpiresAt != null) 'holdExpiresAt': holdExpiresAt,
      if (therapist != null) 'therapist': therapist!.toJson(),
      'priceCents': priceCents,
      'currency': currency,
      if (notes != null) 'notes': notes,
      if (payment != null) 'payment': payment!.toJson(),
      'canCancel': canCancel,
      'refundIfCancelledCents': refundIfCancelledCents,
      if (joinOpensAt != null) 'joinOpensAt': joinOpensAt,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

/// Model representing therapist info in booking item
class BookingTherapistModel {
  final String id;
  final String name;
  final String photoUrl;

  const BookingTherapistModel({
    this.id = '',
    this.name = '',
    this.photoUrl = '',
  });

  factory BookingTherapistModel.fromJson(Map<String, dynamic> json) {
    return BookingTherapistModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
    };
  }
}

/// Model representing payment info in booking item
class BookingPaymentModel {
  final String status;
  final int amountCents;
  final int refundedCents;

  const BookingPaymentModel({
    this.status = '',
    this.amountCents = 0,
    this.refundedCents = 0,
  });

  factory BookingPaymentModel.fromJson(Map<String, dynamic> json) {
    return BookingPaymentModel(
      status: json['status']?.toString() ?? '',
      amountCents: _parseInt(json['amountCents']),
      refundedCents: _parseInt(json['refundedCents']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'amountCents': amountCents,
      'refundedCents': refundedCents,
    };
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
