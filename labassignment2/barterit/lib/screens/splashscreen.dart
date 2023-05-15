import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barterit/screens/registrationscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterIt',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 15),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const RegistrationScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("BarterIt",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Image.asset('assets/images/splash_screen.png', scale: 0.5),
        const Text("Version 1.0.0")
      ],
    )));
  }
}