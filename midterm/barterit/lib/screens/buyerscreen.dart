import 'dart:async';
import 'package:flutter/material.dart';

class BuyerScreen extends StatefulWidget{
  var selectedIndex = 0;
  BuyerScreen({super.key, required this.selectedIndex});

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
  }
  
  class _BuyerScreenState extends State<BuyerScreen> {

      @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("Buyer Screen")),
      body: Column(
        children: [
          const Text("Buyer Screen"),
        ],
      ),
    );
  }
  }
