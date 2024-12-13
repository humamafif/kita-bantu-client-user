class BankModel {
  final int id;
  final String name;

  BankModel({required this.id, required this.name});

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
