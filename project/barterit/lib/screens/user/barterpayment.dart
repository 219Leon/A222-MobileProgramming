import 'package:flutter/material.dart';
import '../../../model/user.dart';
import '../../../model/items.dart';

class BarterPayment extends StatefulWidget{
  final User user;
  final User seller;

  const BarterPayment({super.key, required this.user, required this.seller});
  @override
  State<BarterPayment> createState() => _barterPaymentState();
}

class _barterPaymentState extends State<BarterPayment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}