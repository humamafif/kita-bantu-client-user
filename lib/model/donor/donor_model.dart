class DonorModel {
  final String id, name, phone;

  DonorModel({required this.id, required this.name, required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phone,
    };
  }

  factory DonorModel.fromJson(Map<String, dynamic> json) {
    return DonorModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone_number'],
    );
  }
  static List<DonorModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => DonorModel(
            id: json['id'], name: json['name'], phone: json['phone_number']))
        .toList();
  }
}
