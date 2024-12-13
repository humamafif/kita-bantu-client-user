import 'dart:convert';
import 'package:donasiinapp/const/base_url.dart';
import 'package:donasiinapp/model/transaction/transaction_model.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  Future<TransactionModel?> sendTransaksi(TransactionModel transaksi) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/transactions');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(transaksi.toJson()));

      if (response.statusCode == 201) {
        final transaksiData = json.decode(response.body);
        print("Transaksi created: $transaksiData");
        return TransactionModel.fromJson(transaksiData);
      } else {
        print("Failed to create transaksi: ${response.body}");
        return null;
      }
    } catch (e) {
      print('Exception send transaksi: $e');
      return null;
    }
  }
}
