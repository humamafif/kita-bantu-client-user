import 'dart:developer';
import 'package:donasiinapp/model/bank/bank_model.dart';
import 'package:donasiinapp/model/bank/bank_service.dart';
import 'package:donasiinapp/model/donasi/donasi_model.dart';
import 'package:donasiinapp/model/donasi/donasi_service.dart';
import 'package:donasiinapp/model/donor/donor_model.dart';
import 'package:donasiinapp/model/donor/donor_service.dart';
import 'package:donasiinapp/model/program/program_model.dart';
import 'package:donasiinapp/model/program/program_service.dart';
import 'package:donasiinapp/model/transaction/transaction_model.dart';
import 'package:donasiinapp/model/transaction/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({
    super.key,
  });

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  List<BankModel> _banks = [];
  String? _selectedBank;

  List<ProgramModel> _programs = [];
  String? _selectedProgram;

  DonasiModel? _latestDonasi;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBanks();
    _fetchPrograms();
  }

  Future<void> _fetchLatestDonasi() async {
    try {
      DonasiModel? donasi = await DonasiService().fetchLatest();
      print("Latest Donasi Response: $donasi");
      if (donasi != null) {
        setState(() {
          _latestDonasi = donasi;
        });
      } else {
        print("No latest donation found");
      }
    } catch (e) {
      print("Failed to fetch latest donation: $e");
    }
  }

  void _fetchBanks() async {
    try {
      List<BankModel> banks = await BankService().fetchBanks();
      setState(() {
        _banks = banks;
      });
    } catch (e) {
      print('Failed to load banks: $e');
    }
  }

  Future<void> _fetchPrograms() async {
    final programs = await ProgramService().fetchPrograms();

    try {
      setState(() {
        _programs = programs;
      });
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    }
  }

  void _showDonasiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Form Donasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'No. HP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Nominal Donasi',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Pilih Program',
                  border: OutlineInputBorder(),
                ),
                value: _selectedProgram,
                items: _programs.map((ProgramModel program) {
                  return DropdownMenuItem<String>(
                    value: program.id.toString(),
                    child: Text(program.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProgram = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Pilih Bank',
                  border: OutlineInputBorder(),
                ),
                value: _selectedBank,
                items: _banks.map((BankModel bank) {
                  return DropdownMenuItem<String>(
                    value: bank.id.toString(),
                    child: Text(bank.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBank = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final name = _nameController.text;
                final phone = _phoneController.text;
                final amount = _amountController.text;

                if (name.isNotEmpty && phone.isNotEmpty && amount.isNotEmpty) {
                  double donationAmount = double.parse(amount);
                  ProgramModel selectedProgram = _programs.firstWhere(
                      (program) => program.id.toString() == _selectedProgram);
                  print("goal amount: ${selectedProgram.goalAmount}");
                  print(
                      "goal dana terkumpul: ${selectedProgram.danaTerkumpul}");
                  print("donasi amount: ${donationAmount}");

                  if (donationAmount + selectedProgram.danaTerkumpul >
                      selectedProgram.goalAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Nominal donasi melebihi goal amount program.')),
                    );
                  } else {
                    DonorModel donor = DonorService.createDonor(name, phone);

                    try {
                      final donorResponse =
                          await DonorService().sendDonor(donor);

                      if (donorResponse != null &&
                          donorResponse.id.isNotEmpty) {
                        await DonasiService().sendDonasi(
                          DonasiModel(
                            amount: donationAmount,
                            idDonor: donorResponse.id,
                            idProgram: int.parse(_selectedProgram!),
                          ),
                        );

                        await _fetchLatestDonasi();

                        if (_latestDonasi != null && _latestDonasi!.id != 0) {
                          ProgramModel program = _programs.firstWhere(
                              (program) =>
                                  program.id.toString() == _selectedProgram);

                          await ProgramService().updateProgram(
                            program.id,
                            donationAmount,
                          );

                          await _fetchPrograms();
                          if (program.danaTerkumpul + donationAmount >=
                              program.goalAmount) {
                            await ProgramService()
                                .updateStatus(program.id, "lunas");
                          }

                          String donationId = _latestDonasi!.id.toString();
                          await TransactionService()
                              .sendTransaksi(TransactionModel(
                            bankId: int.parse(_selectedBank!),
                            donationId: int.parse(donationId),
                            status: "sukses",
                          ));

                          setState(() {});

                          print('Latest Donation ID: $donationId');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Donasi terbaru tidak ditemukan')),
                          );
                        }
                      } else {
                        print("Gagal mendapatkan ID donor");
                      }
                    } catch (e) {
                      print("Error Send: $e");
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Harap lengkapi semua data')),
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text('Kirim'),
            )
          ],
        );
      },
    );
  }

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.amber),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.darken,
              ),
              child: const Image(
                image: AssetImage('assets/background.jpg'),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Welcome to Kita ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Bantu",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: MediaQuery.of(context).size.width / 3,
                      child: const Text(
                        "Kami adalah platform yang berdedikasi untuk menghubungkan kebaikan hati para donatur dengan mereka yang membutuhkan. Dengan semangat gotong royong dan kepedulian, kami menciptakan ruang bagi siapa saja yang ingin berkontribusi, untuk menciptakan dampak positif bagi masyarakat.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHovered = true),
                      onExit: (_) => setState(() => _isHovered = false),
                      child: TextButton(
                        onPressed: () {
                          _showDonasiDialog(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              _isHovered ? Colors.red : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: _isHovered ? Colors.red : Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Donasi Sekarang",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 200,
                  backgroundImage: AssetImage("assets/header.png"),
                )
              ],
            ),
          ],
        ));
  }
}
