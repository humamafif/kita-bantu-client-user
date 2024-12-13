import 'package:donasiinapp/const/base_url.dart';
import 'package:donasiinapp/model/donasi/donasi_model.dart';
import 'package:donasiinapp/model/donor/donor_model.dart';
import 'package:donasiinapp/model/program/program_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TabelDonasi extends StatefulWidget {
  @override
  _TabelDonasiState createState() => _TabelDonasiState();
}

class _TabelDonasiState extends State<TabelDonasi> {
  List<DonasiModel> donasiList = [];
  List<DonorModel> donorList = [];
  List<ProgramModel> programList = [];

  // Fetch data donasi
  Future<void> fetchDonasi() async {
    try {
      Uri uri = Uri.parse('$BASE_URL/donations');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          donasiList = DonasiModel.fromJsonList(jsonData['data']);
        });
        fetchDonorAndProgram(); // Fetch donor and program data after fetching donations
      } else {
        print("Failed to fetch donasi: ${response.body}");
      }
    } catch (e) {
      print("Error Donasi: $e");
    }
  }

  // Fetch data donor and program
  Future<void> fetchDonorAndProgram() async {
    try {
      // Fetch donor data
      Uri donorUri = Uri.parse('$BASE_URL/donors');
      final donorResponse = await http.get(donorUri);

      if (donorResponse.statusCode == 200) {
        final donorData = json.decode(donorResponse.body);
        setState(() {
          donorList = DonorModel.fromJsonList(donorData['data']);
        });
      } else {
        print("Failed to fetch donors: ${donorResponse.body}");
      }

      // Fetch program data
      Uri programUri = Uri.parse('$BASE_URL/programs');
      final programResponse = await http.get(programUri);

      if (programResponse.statusCode == 200) {
        final programData = json.decode(programResponse.body);
        setState(() {
          programList = ProgramModel.fromJsonList(programData['data']);
        });
      } else {
        print("Failed to fetch programs: ${programResponse.body}");
      }
    } catch (e) {
      print("Error Donor dan program donasi: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDonasi();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            "DONATUR KAMI",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Orang-orang ",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "baik",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        donasiList.isEmpty || donorList.isEmpty || programList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width * 0.9, // Lebih lebar
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red, width: 2),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            'No.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Donor Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Program Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Jumlah Donasi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      rows: donasiList.asMap().entries.map((entry) {
                        int index = entry.key; // Index untuk iterasi
                        var donasi =
                            entry.value; // Donasi yang sedang di-iterasi

                        // Find donor and program data using their ids
                        var donor = donorList.firstWhere(
                            (donor) => donor.id == donasi.idDonor,
                            orElse: () => DonorModel(
                                  id: "",
                                  name: "Unknown",
                                  phone: "Unknown",
                                ));
                        var program = programList.firstWhere(
                            (program) => program.id == donasi.idProgram,
                            orElse: () => ProgramModel(
                                  id: 0,
                                  name: "Unknown",
                                  danaTerkumpul: 0,
                                  goalAmount: 0,
                                  description: "Unknown",
                                  image: "Unknown",
                                  status: "Unknown",
                                ));

                        return DataRow(cells: [
                          DataCell(Text(
                            (index + 1).toString(),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )), // ID dimulai dari 1
                          DataCell(Text(
                            donor.name,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )), // Display donor name
                          DataCell(Text(
                            program.name,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )), // Display program name
                          DataCell(Text(
                            donasi.amount.toString(),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
