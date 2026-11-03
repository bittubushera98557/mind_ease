/// User model representing the registered user details
class UserModel {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? mobile;
  final String? photo;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    required this.email,
    this.mobile,
    this.photo,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final parsedFirstName = json['firstName']?.toString();
    final parsedLastName = json['lastName']?.toString();
    String fullName = json['name']?.toString() ?? '';
    if (fullName.isEmpty && (parsedFirstName != null || parsedLastName != null)) {
      fullName = '${parsedFirstName ?? ''} ${parsedLastName ?? ''}'.trim();
    }

    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: fullName,
      firstName: parsedFirstName,
      lastName: parsedLastName,
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? json['phone']?.toString(),
      photo: json['photo']?.toString() ?? json['photoUrl']?.toString() ?? json['avatar']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'email': email,
      if (mobile != null) 'mobile': mobile,
      if (photo != null) 'photo': photo,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
