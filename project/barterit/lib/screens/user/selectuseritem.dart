import 'dart:convert';

import 'package:barterit/screens/user/barterconfirm.dart';
import 'package:barterit/screens/mainscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/user.dart';
import '../../../model/items.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/config.dart';

class SelectUserItem extends StatefulWidget {
  final User user;
  final User trader;
  final Item traderItem;

  const SelectUserItem(
      {super.key,
      required this.user,
      required this.trader,
      required this.traderItem});
  @override
  State<SelectUserItem> createState() => _selectUserItemState();
}

class _selectUserItemState extends State<SelectUserItem> {
  List<Item> userItemList = <Item>[];
  Item? _selectedItem;
  String titlecenter = "This list is empty. Add item to proceed.";
  late double screenHeight, screenWidth, resWidth;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadUserItems();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select your Tools for Barter"),
        ),
        body: RefreshIndicator(
            onRefresh: () => _loadUserItems(),
            child: userItemList.isEmpty
                ? Center(
                    child: Text(
                    titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ))
                : Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "You will get in exchange:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: Flexible(
                            flex: 7,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${Config.SERVER}/assets/itemimages/${widget.traderItem.itemId}_1.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                        title: Text(
                          widget.traderItem.itemName.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          "RM ${double.parse(widget.traderItem.itemPrice.toString()).toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Select item for barter:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.separated(
                        itemCount: userItemList.length,
                        itemBuilder: (BuildContext context, index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _selectedItem = userItemList[index];
                                _selectedIndex = index;
                              });
                            },
                            leading: Flexible(
                                flex: 7,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${Config.SERVER}/assets/itemimages/${userItemList[index].itemId}_1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                            title: Text(
                              userItemList[index].itemName.toString(),
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing:  _selectedIndex == index
                                    ? const Icon(Icons.check_box_outlined)
                                    : const Icon(
                                        Icons.check_box_outline_blank_outlined)
                          );
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const Divider();
                        },
                      ))
                    ],
                  )),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 15),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(150, 25)),
                  ),
                  onPressed: (() => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen(
                                    user: widget.user, selectedIndex: 0,
                                    )))
                      }),
                  child: const Text("Return"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(150, 25)),
                  ),
                  onPressed: (() => {
                        _confirmSelectDialog(),
                      }),
                  child: const Text("Proceed"),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _loadUserItems() async {
    http
        .get(
      Uri.parse(
          "${Config.SERVER}/php/loadselleritems.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['items'] != null) {
            setState(() {
              userItemList = List<Item>.from(
                extractdata['items'].map((toolJson) => Item.fromJson(toolJson)),
              );
              print(userItemList[0].itemId);
              titlecenter = "Items available";
            });
          } else {
            setState(() {
              titlecenter = "No items available";
              userItemList.clear();
            });
          }
        } else {
          setState(() {
            titlecenter = "No items available";
            userItemList.clear();
          });
        }
      } else {
        setState(() {
          titlecenter = "No items available";
          userItemList.clear();
        });
      }
    });
  }

  Future<void> _confirmSelectDialog() async {
    if (_selectedIndex == null) {
      Fluttertoast.showToast(
          msg: "Please select a tool",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else{Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
        BarterConfirm(user: widget.user, trader: widget.trader, traderItem: widget.traderItem, userItem: _selectedItem!)
      ));}
  }
}
