import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class MessagesTabScreen extends StatefulWidget {
  final User user;
  const MessagesTabScreen({super.key, required this.user});

  @override
  State<MessagesTabScreen> createState() => _MessagesTabScreenState();
}

class _MessagesTabScreenState extends State<MessagesTabScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
