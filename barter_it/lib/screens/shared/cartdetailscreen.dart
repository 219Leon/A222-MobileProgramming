import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/cart.dart';
import '../../../model/items.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';

class CartDetailScreen extends StatefulWidget {
  final Cart cart;

  const CartDetailScreen(
      {super.key, required this.cart});
  @override
  State<CartDetailScreen> createState() => _cartDetailScreenState();
}

class _cartDetailScreenState extends State<CartDetailScreen> {
  late double screenWidth, screenHeight;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Barter Transaction"),
      ),
      body: Center(
        
      ),
    );
  }

    
}
