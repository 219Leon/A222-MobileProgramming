import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/transaction.dart';
import '../../../model/user.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/config.dart';
import '../trader/traderbarterdetailscreen.dart';


class UserBarterScreen extends StatefulWidget {
  final User user;
  const UserBarterScreen({super.key, required this.user});

  @override
  State<UserBarterScreen> createState() => _UserBarterScreenState();
}

class _UserBarterScreenState extends State<UserBarterScreen> {
  late double screenHeight, screenWidth, cardwitdh;

  String status = "Loading...";
  List<Transaction> orderList = <Transaction>[];
  @override
  void initState() {
    super.initState();
    loadsellerorders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Your Transaction")),
      body: Container(
        child: orderList.isEmpty
            ? Center(
                        child: Column(
                          children: [
                            Padding(
                            
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.08,
                                  24, screenWidth * 0.08, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/emptytransaction.png'),
                                  const Text(
                                    "No bartering transactions yet...",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
            : Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 7,
                              child: Row(
                                children: [
                                   CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                widget.user.id != null
                    ? "${Config.SERVER}/assets/profileimages/${widget.user.id}.jpg"
                    : "${Config.SERVER}/assets/profileimages/0.jpg",
              ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Hello ${widget.user.name}!",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 3,
                            child: Row(children: [
                              IconButton(
                                icon: const Icon(Icons.notifications),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {},
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Text("Your Current Transaction"),
                  Expanded(
                      child: ListView.builder(
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                Transaction mytransaction =
                                    Transaction.fromJson(orderList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            TraderOrderDetailsScreen(
                                              transaction: mytransaction,
                                            )));
                                loadsellerorders();
                              },
                              leading: CircleAvatar(
                                  child: Text((index + 1).toString())),
                              title: Text(
                                  "Receipt: ${orderList[index].barterBill}"),
                              trailing: const Icon(Icons.arrow_forward),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Transaction ID: ${orderList[index].transactionId}"),
                                        Text(
                                            "Status: ${orderList[index].orderStatus}")
                                      ]),
                                  Column(
                                    children: [
                                      Text(
                                        "RM ${double.parse(orderList[index].orderPaid.toString()).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text("")
                                    ],
                                  )
                                ],
                              ),
                            );
                          })),
                ],
              ),
      ),
    );
  }

  void loadsellerorders() {
    http.post(
        Uri.parse("${Config.SERVER}/php/load_userorder.php"),
        body: {"userid": widget.user.id}).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          orderList.clear();
          var extractdata = jsondata['data'];
          extractdata['orders'].forEach((v) {
            orderList.add(Transaction.fromJson(v));
          });
        } else {
          status = "Please register an account first";
          setState(() {});
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "No Transaction found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
        setState(() {});
      }
    });
  }
}