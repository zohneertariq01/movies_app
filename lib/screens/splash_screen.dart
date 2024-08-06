import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "TOP HEADLINES",
              style: TextStyle(
                  fontFamily: GoogleFonts.abel().fontFamily,
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: height * 0.05),
            Image.asset(
              "images/news.png",
              fit: BoxFit.cover,
              height: height * 0.28,
              width: width,
            ),
            SizedBox(height: height * 0.05),
            const SpinKitPianoWave(
              color: Colors.green,
              size: 38.0,
            ),
          ],
        ),
      ),
    );
  }
}
