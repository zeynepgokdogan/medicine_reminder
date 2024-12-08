class HomeModel {
  final String name;

  HomeModel({required this.name});

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      name: map['firstName'] ?? '-',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
