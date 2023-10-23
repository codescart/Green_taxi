import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textWidget(
    {required String text,
    double fontsize = 12,
    fontWeigh = FontWeight.normal,
    required FontWeight fontWeight,
    required Color color,
    required textWidget}) {
  return Text(text,
      style: GoogleFonts.poppins(fontSize: fontsize, fontWeight: fontWeigh),
      textAlign: TextAlign.start);
}
