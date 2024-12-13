import 'dart:convert';
import 'package:donasiinapp/const/base_url.dart';
import 'package:http/http.dart' as http;
import 'program_model.dart';

class ProgramService {
  Future<List<ProgramModel>> fetchPrograms() async {
    final response = await http.get(Uri.parse('$BASE_URL/programs'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body); // Map<String, dynamic>

      if (jsonResponse['data'] != null) {
        List<dynamic> programsJson = jsonResponse['data'];
        List<ProgramModel> programs = programsJson
            .map((program) => ProgramModel.fromJson(program))
            .toList();
        return programs;
      } else {
        throw Exception('No programs found in the response');
      }
    } else {
      throw Exception('Failed to load programs');
    }
  }

  Future<void> updateProgram(int id, double danaTerkumpul) async {
    final url = Uri.parse('$BASE_URL/programs/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'dana_terkumpul':
            danaTerkumpul, // Pastikan mengirimkan nilai dana_terkumpul dengan tipe yang benar
      }),
    );

    if (response.statusCode == 200) {
      print('Program updated successfully');
    } else {
      print('Failed to update program');
      print('Response body: ${response.body}');
    }
  }

  Future<void> updateStatus(int id, String message) async {
    final url = Uri.parse('$BASE_URL/programs/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'status':
            message, // Pastikan mengirimkan nilai dana_terkumpul dengan tipe yang benar
      }),
    );

    if (response.statusCode == 200) {
      print('Program updated successfully');
    } else {
      print('Failed to update program');
      print('Response body: ${response.body}');
    }
  }
}
