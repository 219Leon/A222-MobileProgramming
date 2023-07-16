import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/user.dart';
import '../../../model/items.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';

class BarterConfirm extends StatefulWidget {
  final User user;
  final User trader;
  final Item userItem;
  final Item traderItem;

  const BarterConfirm(
      {super.key,
      required this.user,
      required this.trader,
      required this.userItem,
      required this.traderItem});
  @override
  State<BarterConfirm> createState() => _barterConfirmState();
}

class _barterConfirmState extends State<BarterConfirm> {
  late double screenWidth, screenHeight;
  int userqty = 1;
  double totalprice = 0.0;
  double userprice = 0.0;
  double traderprice = 0.0;
  @override
  void initState() {
    super.initState();

    userprice = double.parse(widget.userItem.itemPrice.toString());
    traderprice = double.parse(widget.traderItem.itemPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if ((userprice*userqty) > traderprice) {
      totalprice = (userprice*userqty) - traderprice;
    } else if (traderprice < (userprice*userqty)) {
      totalprice = traderprice - (userprice*userqty);
    } else if ((userprice*userqty) == traderprice) {
      totalprice = 0.0;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Barter Transaction"),
      ),
      body: Center(
        child: Column(
          children: [
             SizedBox(
              height: screenHeight/10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: screenWidth/3,
                  height: screenHeight/4,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orangeAccent),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "You Give:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          width: 125,
                          height: 125,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${Config.SERVER}/assets/itemimages/${widget.userItem.itemId}_1.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text("(R.p. RM ${userprice.toStringAsFixed(2)})",style: const TextStyle(
                            fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                const Icon(
                  Icons.multiple_stop,
                  size: 50,
                  color: Colors.teal,
                ),
                Container(
                  width: screenWidth/3,
                  height: screenHeight/4,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orangeAccent),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "You Receive:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          width: 125,
                          height: 125,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${Config.SERVER}/assets/itemimages/${widget.traderItem.itemId}_1.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text("(R.p. RM ${traderprice.toStringAsFixed(2)})", style: const TextStyle(
                            fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          
            SizedBox(
              width: screenWidth - 20,
              child: Table(
                 border: TableBorder.all(
                color: Colors.black, style: BorderStyle.none, width: 1),
            columnWidths: {
              0: FixedColumnWidth((screenWidth*0.3)-16),
              1: FixedColumnWidth((screenWidth*0.7)-16),
            },
            children: [
              TableRow(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('You Give:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                    ]),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.userItem.itemName.toString(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                  ),
                ]
              ),
              TableRow(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                       SizedBox(height: 20,)
                    ]),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                     SizedBox(height: 20,)
                  ],
                  ),
                ]
              ),
              TableRow(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('You Receive:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                    ]),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.traderItem.itemName.toString(),style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                  ),
                ]
              )
            ],
              ),
            ),
            const SizedBox(height: 30,),
             Text(
              userprice < traderprice
                  ? "You pay: RM ${(totalprice).toStringAsFixed(2)}"
                  : traderprice < userprice
                      ? "You receive: RM ${(totalprice).toStringAsFixed(2)}"
                      : "No payment needed",
              style: totalprice == 0 || traderprice < userprice
              ?const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 15, 102, 17)
                )
              :const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 50),
             ElevatedButton(
              onPressed: confirmDialog, 
              child: const Text("Proceed with transaction"))
          ],
        ),
      ),
    );
  }

    void confirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Confirm trade item?",
            style: TextStyle(),
          ),
          content: Text("You will give ${widget.userItem.itemName} in exchange for ${widget.traderItem.itemName}.", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addToCart();
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void addToCart() {
    http.post(Uri.parse("${Config.SERVER}/php/addtocart.php"), body: {
      'trader_item_id': widget.traderItem.itemId.toString(),
      'user_item_id': widget.userItem.itemId.toString(),
      'cart_qty': userqty.toString(),
      'cart_price': totalprice.toString(),
      'userid': widget.user.id,
      'traderid': widget.trader.id,
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text("Success")));
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    });
  }
}
