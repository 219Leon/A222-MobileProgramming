import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barterit/screens/mainscreen.dart';
import '../model/user.dart';

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
        const Duration(seconds: 8),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user, selectedIndex: 0,))));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_screen.png'),
                  fit: BoxFit.cover)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/logo-with-text.png", scale:2),
              CircularProgressIndicator(),
              const Text(
                "Version 1.0.0",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        )
      ],
    );
  }
}
