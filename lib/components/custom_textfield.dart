import 'package:crash/conatans/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  CustomTextField(
      {required this.labelText,
      required this.controller,
      this.inputFormatters,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: whiteColor),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.spaceMono(
              textStyle: TextStyle(fontSize: 18, color: whiteColor)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: whiteColor,
              ))),
    );
  }
}
