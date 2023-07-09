import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterIt',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply()),
      ),
      home: const SplashScreen(),
    );
  }
}