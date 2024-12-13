import 'dart:convert';
import 'package:donasiinapp/const/base_url.dart';
import 'package:http/http.dart' as http;
import 'bank_model.dart';

class BankService {
  Future<List<BankModel>> fetchBanks() async {
    final response = await http.get(Uri.parse('$BASE_URL/banks'));

    if (response.statusCode == 200) {
      try {
        List jsonResponse = json.decode(response.body)['data'];
        return jsonResponse.map((bank) => BankModel.fromJson(bank)).toList();
      } catch (e) {
        print('Error parsing JSON: $e');
        throw Exception('Failed to parse banks');
      }
    } else {
      print('Failed to load banks: ${response.statusCode}');
      throw Exception('Failed to load banks');
    }
  }
}
