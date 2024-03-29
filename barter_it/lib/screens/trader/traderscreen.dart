import 'dart:convert';

import 'package:barter_it/screens/trader/additem.dart';
import 'package:barter_it/screens/trader/edititemscreen.dart';
import 'package:barter_it/screens/trader/traderbarterscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user.dart';
import '../../../model/items.dart';
import '../shared/mainmenu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barter_it/config.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../shared/loginscreen.dart';

class TraderScreen extends StatefulWidget {
  final User user;
  final int selectedIndex;
  const TraderScreen({
    super.key,
    required this.selectedIndex,
    required this.user,
  });

  @override
  State<TraderScreen> createState() => _TraderScreenState();
}

class _TraderScreenState extends State<TraderScreen> {
  var _lat, _lng;
  late Position _position;
  List<Item> itemList = <Item>[];
  String titlecenter = "This list is empty. Add item?";
  var placemarks;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _loadItems();
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
              title: const Text("Items for Bartering"),
              actions: [
                 PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Order"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("New Item"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              if (widget.user.id.toString() == "0") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => TraderOrderScreen(
                            user: widget.user,
                          )));
            } else if (value == 1) {

            } 
          }),
        ],
            ),
            body: RefreshIndicator(
              onRefresh: () => _loadItems(),
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
                                children:
                                    List.generate(itemList.length, (index) {
                                  return Card(
                                    elevation: 8,
                                    child: InkWell(
                                      onTap: () {
                                        _showDetails(index);
                                      },
                                      onLongPress: () {
                                        _deleteDialog(index);
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
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                })))
                      ],
                    ),
            ),
            floatingActionButton: widget.user.id != "0"
            ?FloatingActionButton(
              onPressed: _gotoNewItem,
              tooltip: 'Add new item',
              child: const Icon(Icons.add_rounded),
            ): null,
            drawer: MainMenuWidget(user: widget.user)));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  Future<void> _loadItems() async {
    if (widget.user.id == "0") {
      titlecenter = "Please register an account";
      setState(() {});
      return; //exit method if true
    }
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
              itemList = List<Item>.from(
                extractdata['items'].map((toolJson) => Item.fromJson(toolJson)),
              );
              print(itemList[0].itemId);
              titlecenter = "Found";
            });
          } else {
            setState(() {
              titlecenter = "No items available";
              itemList.clear();
            });
          }
        } else {
          setState(() {
            titlecenter = "No items available";
            itemList.clear();
          });
        }
      } else {
        setState(() {
          titlecenter = "No items available";
          itemList.clear();
        });
      }
    });
  }

  Future<void> _gotoNewItem() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login/register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    ProgressDialog progressDialog = ProgressDialog(context,
        blur: 10,
        title: null,
        message: const Text("Searching your current location..."));
    progressDialog.show();
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => AddItemScreen(
                  user: widget.user,
                  position: _position,
                  placemarks: placemarks)));
      _loadItems();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14);
    }
  }

  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  Future<void> _showDetails(int index) async {
    Item item = Item.fromJson(itemList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(user: widget.user, item: item)));
    _loadItems();
  }

  _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(itemList[index].itemName.toString(), 15)}?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure? This cannot be undone.",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteItem(index);
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

  void _deleteItem(index) {
    try {
      http.post(Uri.parse("${Config.SERVER}/php/delete_item.php"),
          body: {'item_id': itemList[index].itemId}).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Item ${itemList[index].itemName} deleted successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadItems();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Unable to delete ${itemList[index].itemName}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _loginForm() {
    print('User ID: ${widget.user.id}');
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  _logoutForm() {
    print('User ID: ${widget.user.id} logout');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout",
            style: TextStyle(),
          ),
          content: const Text("Are your sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                await prefs.setBool('remember', false);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            const LoginScreen()));
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
}
