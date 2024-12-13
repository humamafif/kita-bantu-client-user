import 'package:flutter/material.dart';

class DonasiButton extends StatefulWidget {
  @override
  _DonasiButtonState createState() => _DonasiButtonState();
}

class _DonasiButtonState extends State<DonasiButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: () {
          _showDonasiDialog(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: _isHovered ? Colors.red : Colors.blue,
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text(
          "Donasi Sekarang",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  void _showDonasiDialog(BuildContext context) {
    // ...existing code...
  }
}
