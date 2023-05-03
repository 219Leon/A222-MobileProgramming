import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}): super(key: key);
  
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds:5),
      () =>
    );
  }
  @override
  Widget build(BuildContext context) {
      return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mynelayansplash.png'),
              fit: BoxFit.cover))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("MyNelayan",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)
              ),
            CircularProgressIndicator(),
            Text("Version 1.0.1",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
              ),
            ],),
        )],
    );
  }
}