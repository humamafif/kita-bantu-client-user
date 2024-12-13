class DonasiModel {
  final double amount;
  final int idProgram;
  final String idDonor;
  int id;

  DonasiModel(
      {this.id = 0,
      required this.amount,
      required this.idDonor,
      required this.idProgram});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donor_id': idDonor,
      'program_id': idProgram,
    };
  }

  factory DonasiModel.fromJson(Map<String, dynamic> json) {
    return DonasiModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      idDonor: json['donor_id'],
      idProgram: json['program_id'],
    );
  }

  // Override toString untuk menampilkan data dengan lebih jelas
  @override
  String toString() {
    return 'DonasiModel{id: $id, amount: $amount, donor_id: $idDonor, program_id: $idProgram}';
  }

  static List<DonasiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => DonasiModel.fromJson(item)).toList();
  }
}
