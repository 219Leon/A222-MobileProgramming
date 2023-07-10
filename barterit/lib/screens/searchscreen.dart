import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import '../models/item.dart';
import '../models/user.dart';
import '../config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../shared/mainmenu.dart';
import 'traderitemdetailscreen.dart';

class SearchScreen extends StatefulWidget {
  final User user;
  final int selectedIndex;
  const SearchScreen({
    super.key,
    required this.selectedIndex,
    required this.user,
  });
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  List<Item> itemList = <Item>[];
  String titlecenter = "Nothing found in the list!";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 1;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var color;
  late Item singleItem;

  late User seller;
  var numofpage, curpage = 1;
  int numberofresult = 0;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadItems("all", 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Search Items"),
            actions: [
              IconButton(
                onPressed: () {
                  _loadSearchDialog();
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => _loadItems("all", 1),
            child: itemList.isEmpty
                ? Center(
                    child: Text(
                      titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Current items available (${itemList.length} found)",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                          child: GridView.count(
                              crossAxisCount: rowcount,
                              children: List.generate(itemList.length, (index) {
                                return Card(
                                  elevation: 8,
                                  child: InkWell(
                                    onTap: () {
                                      _showDetails(index);
                                    },
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Flexible(
                                            flex: 7,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${Config.SERVER}/assets/itemimages/${itemList[index].itemId}_1.png",
                                              placeholder: (context, url) =>
                                                  const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )),
                                        Flexible(
                                            flex: 7,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    truncateString(
                                                        itemList[index]
                                                            .itemName
                                                            .toString(),
                                                        15),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}"),
                                                  Text(
                                                    df.format(DateTime.parse(
                                                        itemList[index]
                                                            .itemDate
                                                            .toString())),
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              }))),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: numofpage,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if ((curpage - 1) == index) {
                                color = Colors.blue;
                              } else {
                                color = Colors.black;
                              }
                              return TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // Prevents dialog from closing on outside tap
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CircularProgressIndicator(), // Loading indicator
                                              SizedBox(width: 10),
                                              Text(
                                                  "Loading page..."), // Optional text to display
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    curpage = index + 1;
                                    _loadItems(search, index + 1).then((_) {
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        Navigator.pop(context);
                                      });
                                    });
                                  },
                                  child: Text(
                                    (index + 1).toString(),
                                    style:
                                        TextStyle(color: color, fontSize: 18),
                                  ));
                            }),
                      ),
                    ],
                  ),
          ),
          drawer: MainMenuWidget(user: widget.user)),
    );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadItems(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  Future<void> _loadItems(String search, int pageno) async {
    setState(() {
      curpage = pageno;
      numofpage ??= 1;
    });

    http
        .get(
      Uri.parse(
          "${Config.SERVER}/php/loadallitems.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading all items..."),
        title: null,
      );
      progressDialog.show();
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['items'] != null) {
            print("Success");
            setState(() {
              numofpage = int.parse(jsondata['numofpage']);
              numberofresult = int.parse(jsondata['numberofresult']);
              itemList = List<Item>.from(
                extractdata['items'].map((toolJson) => Item.fromJson(toolJson)),
              );
              titlecenter = "Found";
            });
          } else {
            print("Failed");
            setState(() {
              titlecenter = "No Items Available";
              itemList.clear();
            });
          }
        }
      } else {
        print("Error");
        setState(() {
          titlecenter = "No Items Available";
          itemList.clear();
        });
      }

      progressDialog.dismiss();
    });
  }

  _showDetails(int index) async {
    Item item = Item.fromJson(itemList[index].toJson());
    loadSingleSeller(index);
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading details..."),
      title: null,
    );
    progressDialog.show();
    await Future.delayed(const Duration(seconds: 1));
    if (itemList[index].userId == widget.user.id) {
      progressDialog.dismiss();
      Fluttertoast.showToast(
        msg: "You cannot trade your own tool!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
    } else if (seller.id != "0") {
      progressDialog.dismiss();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => SellerItemDetailScreen(
                  user: widget.user, item: singleItem, seller:seller)));
    }
  }

  loadSingleSeller(int index) async {
    http.post(Uri.parse("${Config.SERVER}/php/loadseller.php"),
        body: {"sellerid": itemList[index].userId}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        seller = User.fromJson(jsonResponse['data']);
      }
    });
  }
}
