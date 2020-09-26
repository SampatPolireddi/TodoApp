import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screens/homepage.dart';
import 'package:animated_splash/animated_splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: AnimatedSplash(
        imagePath: 'assets/images/logo.png',
        home: Homepage(),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration,
      ),
    );
  }
}