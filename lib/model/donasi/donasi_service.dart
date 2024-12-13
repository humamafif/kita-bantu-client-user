import 'dart:convert';
import 'package:donasiinapp/const/base_url.dart';
import 'package:http/http.dart' as http;

import 'package:donasiinapp/model/donasi/donasi_model.dart';

class DonasiService {
  Future<void> sendDonasi(DonasiModel donasi) async {
    try {
      Uri uri = Uri.parse('$BASE_URL/donations');
      final responseDonasi = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(donasi.toJson()));
      print('Request body: ${json.encode(donasi.toJson())}');
      print('Response status: ${responseDonasi.statusCode}');
      print('Response body: ${responseDonasi.body}');

      if (responseDonasi.statusCode == 201) {
        // return DonasiModel.fromJson(json.decode(responseDonasi.body));
        print("Data send successfully ${responseDonasi.body}");
      } else {
        print("Failed to send data ${responseDonasi.body}");
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to donate: $e');
    }
  }

  Future<DonasiModel> fetchLatest() async {
    try {
      Uri uri = Uri.parse('$BASE_URL/donations/latest');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print("Response Body: $responseBody");

        // Periksa apakah respons mengandung 'data' dan bukan null
        final responseData = json.decode(response.body);

        if (responseData != null && responseData['data'] != null) {
          final donasiData = DonasiModel.fromJson(responseData['data']);
          print("Donasi fetched: $donasiData"); // Sekarang mencetak data objek
          return donasiData;
        } else {
          print("Data donasi tidak ditemukan atau kosong");
          throw Exception('No donation data found');
        }
      } else {
        print("Failed to fetch donasi: ${response.body}");
        throw Exception('Failed to fetch donasi');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to fetch donasi: $e');
    }
  }

  // Future<List<DonasiModel>> fetchDonasiList() async {
  //   final Uri uri =
  //       Uri.parse('$BASE_URL/donations'); // Sesuaikan dengan endpoint API lokal
  //   final response = await http.get(uri);

  //   if (response.statusCode == 200) {
  //     // Jika request berhasil, parse data dari JSON
  //     final List<dynamic> data = json.decode(response.body)["data"];
  //     return data.map((item) => DonasiModel.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load donasi');
  //   }
  // }
}
