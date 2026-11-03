/// Model representing Support Resource Item
class SupportResourceItemModel {
  final String id;
  final String name;
  final String description;
  final String number;

  const SupportResourceItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.number,
  });

  factory SupportResourceItemModel.fromJson(Map<String, dynamic> json) {
    return SupportResourceItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'number': number,
    };
  }
}

/// Model representing Support Resources API response GET /support-resources
class SupportResourcesResponseModel {
  final String region;
  final String? verifiedOn;
  final String? note;
  final List<SupportResourceItemModel> resources;

  const SupportResourcesResponseModel({
    this.region = '',
    this.verifiedOn,
    this.note,
    this.resources = const [],
  });

  factory SupportResourcesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResources = json['resources'];
    List<SupportResourceItemModel> resourcesList = [];
    if (rawResources is List) {
      resourcesList = rawResources
          .whereType<Map<String, dynamic>>()
          .map((item) => SupportResourceItemModel.fromJson(item))
          .toList();
    }

    return SupportResourcesResponseModel(
      region: json['region']?.toString() ?? '',
      verifiedOn: json['verifiedOn']?.toString(),
      note: json['note']?.toString(),
      resources: resourcesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'region': region,
      if (verifiedOn != null) 'verifiedOn': verifiedOn,
      if (note != null) 'note': note,
      'resources': resources.map((r) => r.toJson()).toList(),
    };
  }
}
