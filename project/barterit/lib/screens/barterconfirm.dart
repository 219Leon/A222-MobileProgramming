import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../model/items.dart';

class BarterConfirm extends StatefulWidget{
  final User user;
  final User seller;

  const BarterConfirm({super.key, required this.user, required this.seller});
  @override
  State<BarterConfirm> createState() => _barterConfirmState();
}

class _barterConfirmState extends State<BarterConfirm>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}