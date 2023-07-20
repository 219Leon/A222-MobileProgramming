import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import '../../screens/user/billscreen.dart';
import 'package:flutter/material.dart';
import '../../../model/cart.dart';
import '../../../model/user.dart';
import '../../model/transaction.dart';
import '../../config.dart';
import 'package:http/http.dart' as http;

import 'mainmenu.dart';

class BarterScreen extends StatefulWidget {
  final User user;
  final int selectedIndex;

  const BarterScreen(
      {super.key, required this.user, required this.selectedIndex});

  @override
  State<BarterScreen> createState() => _BarterScreenState();
}

class _BarterScreenState extends State<BarterScreen> {
  List<Cart> cartList = <Cart>[];
  List<Transaction> transactionList = <Transaction>[];

  late double screenHeight, screenWidth;
  late int axiscount = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int selectedTabIndex = 0;
  double totalprice = 0.00;

  @override
  void initState() {
    super.initState();
    loadcart();
    loadTraderOrders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    var tabText = const TextStyle(fontSize: 18);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Barter Cart"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
          ],
        ),
        body: Column(children: [
          const SizedBox(height: 30),
          widget.user.id == "0"
              ? Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.08, 24, screenWidth * 0.08, 0),
                        child: const Text(
                          "Please register/login to access",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : cartList.isEmpty
                  ? Center(
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
                    )
                  : Expanded(
                      child: ListView.builder(
                      itemCount: cartList.length,
                      padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.antiAlias,
                          elevation: 3,
                          child: InkWell(
                            onTap: () {},
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.tealAccent)),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Give",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                              width: 98,
                                              height: 98,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "${Config.SERVER}/assets/itemimages/${cartList[index].itemId}_1.png",
                                              placeholder: (context, url) =>
                                                  const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) => Text(
                                                      "${cartList[index].itemId}")),
                                        ),
                                      ],
                                    )),
                              ),
                              const Icon(Icons.multiple_stop),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.tealAccent)),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Receive",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                              width: 98,
                                              height: 98,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "${Config.SERVER}/assets/itemimages/${cartList[index].traderItemId}_1.png",
                                              placeholder: (context, url) =>
                                                  const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) => Text(
                                                      "${cartList[index].itemId}")),
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                children: [
                                  Text(
                                    "RM ${double.parse(cartList[index].cartPrice.toString()).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (content) =>
                                                        BillScreen(
                                                          user: widget.user,
                                                          totalprice:
                                                              totalprice,
                                                        )));
                                            loadcart();
                                          },
                                          icon: const Icon(
                                              Icons.shopping_cart_checkout,
                                              size: 25)),
                                      IconButton(
                                          onPressed: () {
                                            deleteCartDialog(index);
                                          },
                                          icon: const Icon(Icons.delete_outline,
                                              size: 25)),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        );
                      },
                    )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price RM ${totalprice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => BillScreen(
                                        user: widget.user,
                                        totalprice: totalprice,
                                      )));
                          loadcart();
                        },
                        child: const Text("Check Out"))
                  ],
                )),
          )
        ]),
        drawer: MainMenuWidget(user: widget.user));
  }

  Future<void> loadcart() async {
    http.post(Uri.parse("${Config.SERVER}/php/load_cart.php"), body: {
      "userid": widget.user.id,
    }).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          if (extractdata['carts'] != null) {
            setState(() {
              cartList = List<Cart>.from(extractdata['carts']
                  .map((toolJson) => Cart.fromJson(toolJson)));
            });
          }
        } else {
          Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }

  void deleteCartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteCart(index);
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

  void deleteCart(int index) {
    http.post(Uri.parse("${Config.SERVER}/php/delete_cart.php"), body: {
      "cartid": cartList[index].cartId,
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadcart();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete Failed")));
      }
    });
  }

  void loadTraderOrders() {
    http.post(Uri.parse("${Config.SERVER}/php/load_traderorder.php"), body: {
      "traderrid": widget.user.id,
    }).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          if (extractdata['carts'] != null) {
            setState(() {
              cartList = List<Cart>.from(extractdata['carts']
                  .map((toolJson) => Cart.fromJson(toolJson)));
            });
          }
        } else {
          Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }
}
