class TransactionModel {
  final int bankId, donationId;
  final String status;

  TransactionModel(
      {required this.bankId, required this.donationId, required this.status});

  Map<String, dynamic> toJson() {
    return {
      'bank_id': bankId,
      'donation_id': donationId,
      'status': status,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      bankId: json['bank_id'],
      donationId: json['donation_id'],
      status: json['status'],
    );
  }
}
