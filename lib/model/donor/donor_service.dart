import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:donasiinapp/const/base_url.dart';
import 'package:donasiinapp/model/donor/donor_model.dart';
import 'package:uuid/uuid.dart';

class DonorService {
  Future<DonorModel?> sendDonor(DonorModel donor) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/donors');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(donor.toJson()));

      if (response.statusCode == 201) {
        final donorData = json.decode(response.body);
        print("Donor created: $donorData");

        // Pastikan response berisi data yang lengkap dan ID donor
        if (donorData['data'] != null) {
          return DonorModel.fromJson(donorData['data']);
        } else {
          print("Data donor tidak ditemukan di response.");
          return null;
        }
      } else {
        print("Failed to create donor: ${response.body}");
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static DonorModel createDonor(String name, String phone) {
    String id = Uuid().v4(); // ID acak dengan UUID
    return DonorModel(id: id, name: name, phone: phone);
  }
}
