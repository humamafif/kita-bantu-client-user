import 'dart:developer';

import 'package:donasiinapp/model/program/program_service.dart';
import 'package:donasiinapp/pages/program/grid_program.dart';
import 'package:flutter/material.dart';
import 'package:donasiinapp/model/program/program_model.dart'; // Import model

class ProgramSection extends StatefulWidget {
  const ProgramSection({
    super.key,
  });

  @override
  State<ProgramSection> createState() => _ProgramSectionState();
}

class _ProgramSectionState extends State<ProgramSection> {
  List<ProgramModel> _programs = []; // Gunakan ProgramModel alih-alih dynamic

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  void _fetchPrograms() async {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              "PROGRAMS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mau berbuat baik ",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "apa hari ini?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ProgramGrid(programs: _programs),
        ],
      ),
    );
  }
}
