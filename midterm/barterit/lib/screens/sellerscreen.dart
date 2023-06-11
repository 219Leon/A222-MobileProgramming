import 'dart:async';
import 'package:flutter/material.dart';

class SellerScreen extends StatefulWidget{
  final int selectedIndex;
  const SellerScreen({super.key, required this.selectedIndex});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
  }
  
  class _SellerScreenState extends State<SellerScreen> {

      @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("Seller Screen")),
      body: Column(
        children: [
          const Text("Seller Screen"),
        ],
      ),
    );
  }
  }
