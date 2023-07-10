import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barterit/model/user.dart';
import 'package:barterit/model/items.dart';

class ReceivedTransactionScreen extends StatefulWidget {
  final User user;
  final Item useritem;
  const ReceivedTransactionScreen( 
      {super.key, required this.user, required this.useritem});

  @override
  State<ReceivedTransactionScreen> createState() => _ReceivedTransactionScreenState();
}

class _ReceivedTransactionScreenState extends State<ReceivedTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}