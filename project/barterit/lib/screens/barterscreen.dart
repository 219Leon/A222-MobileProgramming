import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../model/items.dart';
import '../model/transaction.dart';
import '../shared/mainmenu.dart';
import '../screens/receivetransactionscreen.dart';
import 'dart:math' as math;
import 'package:barterit/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BarterScreen extends StatefulWidget {
  final User user;
  final int selectedIndex;
  const BarterScreen({
    super.key,
    required this.selectedIndex,
    required this.user,
  });

  @override
  State<BarterScreen> createState() => _BarterScreenState();
}

class _BarterScreenState extends State<BarterScreen> {
  late double screenWidth, screenHeight;
  final df = DateFormat('d MMMM');
  int selectedTabIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<Transaction> sentTransactionList = [];
  List<Transaction> receivedTransactionList = [];

  List<String> userItemIdList = [];
  List<Item> userItemList = [];

  List<String> itemIdList = [];
  Map<String, Item> itemMap = {};
  Map<String, int> countMap = {};

  @override
  void initState() {
    loadSentTransactionList();
    loadReceivedTransactionList();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    var tabText = const TextStyle(fontSize: 18);

    return Scaffold(
        appBar: AppBar(title: const Text("Barter List")),
        body: Column(children: [
          SizedBox(height: screenHeight * 0.05),
          Align(
            alignment: Alignment.center,
            child: CupertinoSlidingSegmentedControl<int>(
              children: {
                0: Text('\t\tSent\t\t', style: tabText),
                1: Text('\t\tReceived\t\t', style: tabText),
                2: Text('\t\tOngoing\t\t', style: tabText),
              },
              onValueChanged: (index) {
                setState(() {
                  selectedTabIndex = index!;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
              groupValue: selectedTabIndex,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedTabIndex = index;
                });
              },
              children: [
                if (widget.user.id == "0")
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.08, 24, screenWidth * 0.08, 0),
                          child: const Text(
                            "Please Register/login to access",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.user.id != "0" && sentTransactionList.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.08, 24, screenWidth * 0.08, 0),
                          child: const Text(
                            "No bartering transactions yet...",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.user.id != "0" && sentTransactionList.isNotEmpty)
                  Center(
                      child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: sentTransactionList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.tealAccent)),
                                            width: screenWidth * 0.25,
                                            height: screenHeight * 0.35,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: screenWidth * 0.3,
                                                  color: Colors.tealAccent,
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text("You Receive",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    width: screenWidth * 0.25,
                                                    height: screenHeight * 0.25,
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        "${Config.SERVER}/assets/itemimages/${sentTransactionList[index].receiveId}_1.png",
                                                    placeholder: (context,
                                                            url) =>
                                                        const LinearProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.multiple_stop),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    width: 2,
                                                    color:
                                                        Colors.orangeAccent)),
                                            width: screenWidth * 0.25,
                                            height: screenHeight * 0.35,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: screenWidth * 0.3,
                                                  color: Colors.orangeAccent,
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text("You Give",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    width: screenWidth * 0.25,
                                                    height: screenHeight * 0.25,
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        "${Config.SERVER}/assets/itemimages/${sentTransactionList[index].giveId}_1.png",
                                                    placeholder: (context,
                                                            url) =>
                                                        const LinearProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.03),
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          height: screenHeight * 0.35,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                itemMap[sentTransactionList[
                                                                index]
                                                            .giveId]
                                                        ?.itemName
                                                        .toString() ??
                                                    "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              Expanded(child: Container()),
                                              Text(
                                                "RM ${double.parse(itemMap[sentTransactionList[index].giveId]!.itemPrice.toString()).toStringAsFixed(2)}",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.teal,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                "Qty: ${itemMap[sentTransactionList[index].giveId]!.itemQty.toString()}",
                                                softWrap: true,
                                                maxLines: 1,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    removeTransactionDialog(
                                                        index);
                                                    setState(() {});
                                                  },
                                                  child:
                                                      Text("Transaction Sent"))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      indent: 8,
                                      endIndent: 8,
                                      thickness: 1,
                                    )
                                  ],
                                );
                              }))
                    ],
                  )),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      if (widget.user.id == "0")
                        Column(
                          children: const [
                            Text("Please Register/login to access",
                                style: TextStyle(
                                  fontSize: 18,
                                ))
                          ],
                        ),
                      if (widget.user.id != "0" &&
                          receivedTransactionList.isEmpty)
                        Column(
                          children: const [
                            Text("No item requested for barter"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("The list is currently empty")
                          ],
                        ),
                      if (widget.user.id != "0" &&
                          receivedTransactionList.isNotEmpty)
                        Expanded(
                            child: ListView.builder(
                                itemCount: userItemList.length,
                                padding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                                    0, screenWidth * 0.02, 0),
                                itemBuilder: (context, index) {
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 3,
                                      child: InkWell(
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (content) =>
                                                        ReceivedTransactionScreen(
                                                          user: widget.user,
                                                          useritem:
                                                              userItemList[
                                                                  index],
                                                        ))).then((value) =>
                                                refreshReceivedTransaction());
                                          },
                                          child: Row(children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    width: screenWidth * 0.25,
                                                    height: screenHeight * 0.25,
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        "${Config.SERVER}/assets/itemimages/${userItemList[index].itemId}_1.png",
                                                    placeholder: (context,
                                                            url) =>
                                                        const LinearProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: screenWidth * 0.25 + 16,
                                              width: screenWidth * 0.55,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Text(
                                                        userItemList[index]
                                                            .itemName
                                                            .toString(),
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        df.format(DateTime
                                                            .parse(userItemList[
                                                                    index]
                                                                .itemDate
                                                                .toString())),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    Expanded(
                                                        child: Container()),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "RM ${userItemList[index].itemPrice}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18)),
                                                        Expanded(
                                                            child: Container()),
                                                        Text(
                                                            "Offer: ${countMap[userItemList[index].itemId]}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.orange,
                                                            )),
                                                        const SizedBox(
                                                            width: 28)
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ]),
                                            ),
                                            Transform(
                                              alignment: Alignment.center,
                                              transform:
                                                  Matrix4.rotationY(math.pi),
                                              child: const Icon(
                                                Icons.arrow_back_ios_new,
                                              ),
                                            )
                                          ])));
                                })),
                    ],
                  ),
                ),
                const Placeholder()
              ],
            ),
          )
        ]),
        drawer: MainMenuWidget(user: widget.user));
  }

  void removeTransactionDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Remove Offer?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteTransaction(sentTransactionList[index].giveId.toString(),
                    sentTransactionList[index].receiveId.toString());
                sentTransactionList.remove(sentTransactionList[index]);
                Navigator.of(context).pop();
                setState(() {});
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

  void deleteTransaction(String giveId, String receiveId) {
    http.post(Uri.parse("${Config.SERVER}/php/delete_transaction.php"),
        body: {});
  }

  Future loadSentTransactionList() async {
    http.post(Uri.parse("${Config.SERVER}/php/load_transaction.php"), body: {
      "userid": widget.user.id,
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['transactions'].forEach((v) {
          sentTransactionList.add(Transaction.fromJson(v));
        });
      }
      loadItemIdList();
    });
  }

  void loadItemIdList() {
    if (sentTransactionList.isEmpty) return;

    for (var element in sentTransactionList) {
      if (!itemIdList.contains(element.giveId.toString())) {
        itemIdList.add(element.giveId.toString());
      }
      if (!itemIdList.contains(element.receiveId.toString())) {
        itemIdList.add(element.receiveId.toString());
      }
    }
    loadSentTransactionList();
  }

  void loadSentTransactionItems() {
    http.post(Uri.parse("${Config.SERVER}/php/load_items.php"),
        body: {"itemIdList": itemIdList.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          Item item = Item.fromJson(v);
          itemMap[item.itemId.toString()] = item;
        });
      }
      setState(() {});
    });
  }

  Future loadReceivedTransactionList() async {
    http.post(Uri.parse("${Config.SERVER}/php/load_transaction.php"), body: {
      "useridreceived": widget.user.id,
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['transactions'].forEach((v) {
          sentTransactionList.add(Transaction.fromJson(v));
        });
      }
      countTransactions();
    });
  }

  void countTransactions() {
    for (Transaction element in receivedTransactionList) {
      countMap[element.receiveId.toString()] =
          (countMap[element.receiveId.toString()] ?? 0) + 1;

      if (!userItemIdList.contains(element.receiveId)) {
        userItemIdList.add(element.receiveId.toString());
      }
    }
    loadReceivedTransactionItems();
  }

  void loadReceivedTransactionItems() {
    http.post(Uri.parse("${Config.SERVER}/php/load_items.php"),
        body: {"itemIdList": itemIdList.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          userItemList.add(Item.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  void refreshSentTransaction() {
    sentTransactionList.clear();
    itemIdList.clear();
    itemMap.clear();
    loadSentTransactionList();
  }

  void refreshReceivedTransaction() {
    receivedTransactionList.clear();
    itemIdList.clear();
    itemMap.clear();
    loadReceivedTransactionList();
  }
}
