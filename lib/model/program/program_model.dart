class ProgramModel {
  final int id;
  final String name;
  final String description;
  final int goalAmount;
  final int danaTerkumpul;
  final String status;
  final String image;

  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.goalAmount,
    required this.danaTerkumpul,
    required this.status,
    required this.image,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      goalAmount: json['goal_amount'],
      danaTerkumpul: json['dana_terkumpul'],
      status: json['status'],
      image: json['image'],
    );
  }

  static List<ProgramModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ProgramModel(
              id: json['id'],
              name: json['name'],
              description: json['description'],
              goalAmount: json['goal_amount'],
              danaTerkumpul: json['dana_terkumpul'],
              status: json['status'],
              image: json['image'],
            ))
        .toList();
  }
}
