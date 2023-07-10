import 'dart:async';

import 'package:flutter/material.dart';
import '../screens/mainscreen.dart';
import '../models/user.dart';

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
    late double screenHeight, screenWidth;

  @override
  void initState() {
 super.initState();
    User user = User(
        id: "0",
        email: "unknown",
        name: "unregistered",
        address: "na",
        phone: "0123456789",
        regdate: "0",
        credit: "0",
        );
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user, selectedIndex: 0,))));
  }

  @override
  Widget build(BuildContext context) {
    
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Splash_Screen.png'),
                  fit: BoxFit.cover)
              ),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo-with-text.png', scale: 4),
          CircularProgressIndicator(),
          const Text(
            "Version 1.0.1",
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black
            ),
          )
        ],)),
      ],
    );
  }
}
