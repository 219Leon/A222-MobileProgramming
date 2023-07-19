import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/config.dart';
import '../../model/items.dart';
import '../../model/user.dart';
import 'package:http/http.dart' as http;

import 'useritemdetails.dart';

class UserMoreScreen extends StatefulWidget {
  final Item userItem;
  final User user;
  const UserMoreScreen(
      {super.key, required this.userItem, required this.user});

  @override
  State<UserMoreScreen> createState() => _UserMoreScreenState();
}

class _UserMoreScreenState extends State<UserMoreScreen> {
  List<Item> itemList = <Item>[];
    late User seller;
  int numberofresult = 0;
  late double screenHeight, screenWidth, cardwitdh;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      );

  @override
  void initState() {
    super.initState();
    seller = User(
        id: "0",
        email: "unregistered@email.com",
        name: "unregistered",
        address: "na",
        phone: "0123456789",
        regdate: "1970/01/01",
        credit: "0");
    loadSellerItems();
    loadSeller();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("More from ")),
      body: Column(
        children: [
          SizedBox(
              height: screenHeight / 8,
              width: screenWidth,
              child: Card(
                  child: user.name == "na"
                      ? const Center(child: Text("Loading..."))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Store Owner\n${user.name}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),
          const Divider(),
          itemList.isEmpty
              ? Container()
              : Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(itemList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Item useritem =
                                  Item.fromJson(itemList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => TraderItemDetails(
                                            user: widget.user,
                                            item: useritem, 
                                            trader: seller,
                                          )));
                            },
                            child: Column(children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config.SERVER}/assets/itemimages/${itemList[index].itemId}_1.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                itemList[index].itemName.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              
                            ]),
                          ),
                        );
                      })))
        ],
      ),
    );
  }

  void loadSellerItems() {
    http.post(
        Uri.parse("${Config.SERVER}/php/load_singleseller.php"),
        body: {
          "sellerid": widget.userItem.userId,
        }).then((response) {
      //print(response.body);
      //log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void loadSeller() {
    http.post(Uri.parse("${Config.SERVER}/mynelayan/php/load_user.php"),
        body: {
          "userid": widget.userItem.userId,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }
}