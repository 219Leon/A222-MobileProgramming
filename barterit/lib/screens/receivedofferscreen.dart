import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';

class ReceivedOfferScreen extends StatefulWidget {
  final User user;
  final Item useritem;
  const ReceivedOfferScreen(
      {super.key, required this.user, required this.useritem});

  @override
  State<ReceivedOfferScreen> createState() => _ReceivedOfferScreenState();
}

class _ReceivedOfferScreenState extends State<ReceivedOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
