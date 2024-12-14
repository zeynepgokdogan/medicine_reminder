class ProfileModel {
  final String name;
  final String surname;

  ProfileModel({required this.surname, required this.name});

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['firstName'] ?? '-',
      surname: map['lastName'] ?? '-',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
    };
  }
}
