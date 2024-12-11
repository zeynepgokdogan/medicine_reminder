class ProfileModel {
  final String name;

  ProfileModel({required this.name});

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['firstName'] ?? '-',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
