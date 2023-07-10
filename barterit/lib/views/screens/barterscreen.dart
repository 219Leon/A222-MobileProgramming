import 'dart:convert';

import 'package:barterit/views/screens/receivedofferscreen.dart';
import 'package:barterit/views/screens/traderitemdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/offer.dart';
import 'package:barterit/models/item.dart';

import 'dart:math' as math;
import 'package:barterit/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BarterTabScreen extends StatefulWidget {
  final User user;
  const BarterTabScreen({super.key, required this.user});

  @override
  State<BarterTabScreen> createState() => _BarterTabScreenState();
}

class _BarterTabScreenState extends State<BarterTabScreen> {
  late double screenWidth, screenHeight;
  final df2 = DateFormat('d MMMM');
  final PageController _pageController = PageController(initialPage: 0);
  int selectedTabIndex = 0;
  List<Offer> sentOfferList = [];
  List<Offer> receivedOfferList = [];

  // This is for received offer item list
  List<String> userItemIdList = [];
  List<Item> userItemList = [];

  // This is for sent offer item list
  List<String> itemIdList = [];
  Map<String, Item> itemMap = {};
  Map<String, int> countMap = {};

  @override
  void initState() {
    loadSentOfferList();
    loadReceivedOfferList();
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    var tabText = const TextStyle(fontSize: 18);

    return Scaffold(
        body: Column(
      children: [
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
              if (sentOfferList.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.08, 24, screenWidth * 0.08, 0),
                        child: Text(
                          "You didn't send any offer to barter",
                          style: TextStyle(
                            color: isDark ? Colors.grey : Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (sentOfferList.isNotEmpty)
                Center(
                    child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: sentOfferList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: isDark
                                                    ? const Color.fromARGB(
                                                        255, 173, 96, 33)
                                                    : Colors.orangeAccent,
                                                width: 2),
                                          ),
                                          width: screenWidth * 0.25,
                                          height: screenWidth * 0.35,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 24,
                                                  width: screenWidth * 0.3,
                                                  color: isDark
                                                      ? const Color.fromARGB(
                                                          255, 173, 96, 33)
                                                      : Colors.orangeAccent,
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Take",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                              Expanded(child: Container()),
                                              GestureDetector(
                                                onTap: () async {
                                                  Item item = itemMap[
                                                          sentOfferList[index]
                                                              .takeId] ??
                                                      Item();

                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (content) =>
                                                              TraderItemDetailScreen(
                                                                  user: widget
                                                                      .user,
                                                                  useritem:
                                                                      item,
                                                                  page:
                                                                      "user"))).then(
                                                      (value) {
                                                    refreshSentOffer();
                                                  });
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    width: screenWidth * 0.25,
                                                    height: screenWidth * 0.25,
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        "${MyConfig().SERVER}/barterit/assets/items/${sentOfferList[index].takeId}-1.png",
                                                    placeholder: (context,
                                                            url) =>
                                                        const LinearProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    const Icon(Icons.multiple_stop),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: isDark
                                                    ? const Color.fromARGB(
                                                        255, 34, 76, 110)
                                                    : Colors.blue,
                                                width: 2),
                                          ),
                                          width: screenWidth * 0.25,
                                          height: screenWidth * 0.35,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 24,
                                                  width: screenWidth * 0.3,
                                                  color: isDark
                                                      ? const Color.fromARGB(
                                                          255, 34, 76, 110)
                                                      : Colors.blue,
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Give",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                              Expanded(child: Container()),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  width: screenWidth * 0.25,
                                                  height: screenWidth * 0.25,
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      "${MyConfig().SERVER}/barterit/assets/items/${sentOfferList[index].giveId}-1.png",
                                                  placeholder: (context, url) =>
                                                      const LinearProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.03,
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.30,
                                      height: screenWidth * 0.35,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemMap[sentOfferList[index].giveId]
                                                    ?.itemName
                                                    .toString() ??
                                                "",
                                            maxLines: 2,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Text(
                                            "RM ${itemMap[sentOfferList[index].giveId]!.itemPrice.toString()}",
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.orange),
                                          ),
                                          Text(
                                            "Qty: ${itemMap[sentOfferList[index].giveId]!.itemQty.toString()}",
                                            softWrap: true,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.grey
                                                    : Colors.grey[700]),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isDark
                                                    ? Colors.grey[700]
                                                    : const Color.fromARGB(
                                                        255, 190, 101, 27),
                                              ),
                                              onPressed: () {
                                                removeOfferDialog(index);
                                                setState(() {});
                                              },
                                              child: Text("Offer Sent",
                                                  style: TextStyle(
                                                      color: isDark
                                                          ? Colors.grey[300]
                                                          : const Color
                                                                  .fromARGB(255,
                                                              240, 222, 194))))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(
                                    indent: 8, endIndent: 8, thickness: 1),
                              ],
                            );
                          }),
                    )
                  ],
                )),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    if (receivedOfferList.isEmpty)
                       Column(
                        children: const [
                          Text(
                            "No item requested for barter",
                            style: TextStyle(fontSize: 20, height: 1.5),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "The list is currently empty",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    if (receivedOfferList.isNotEmpty)
                      Expanded(
                          child: ListView.builder(
                              itemCount: userItemList.length,
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                              itemBuilder: (context, index) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 2,
                                    child: InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (content) =>
                                                      ReceivedOfferScreen(
                                                        user: widget.user,
                                                        useritem:
                                                            userItemList[index],
                                                      ))).then((value) {
                                            refreshReceivedOffer();
                                          });
                                        },
                                        child: Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                width: screenWidth * 0.25,
                                                height: screenWidth * 0.25,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "${MyConfig().SERVER}/barterit/assets/items/${userItemList[index].itemId}-1.png",
                                                placeholder: (context, url) =>
                                                    const LinearProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
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
                                                      df2.format(DateTime.parse(
                                                          userItemList[index]
                                                              .itemDate
                                                              .toString())),
                                                      style: const TextStyle(
                                                          color: Colors.grey)),
                                                  Expanded(child: Container()),
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
                                                      SizedBox(width: 28)
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
                                              color: Colors.grey,
                                            ),
                                          )
                                        ])));
                              })),
                  ],
                ),
              ),
              const Placeholder(),
            ],
          ),
        )
      ],
    ));
  }

  void removeOfferDialog(int index) {
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
                deleteOffer(sentOfferList[index].giveId.toString(),
                    sentOfferList[index].takeId.toString());
                sentOfferList.remove(sentOfferList[index]);
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

  void insertOffer(String string) {}

  Future loadSentOfferList() async {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_offer.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['offers'].forEach((v) {
          sentOfferList.add(Offer.fromJson(v));
        });
      }
      loadItemIdList();
    });
  }

  // load items based on item id contains within offer list
  void loadItemIdList() {
    if (sentOfferList.isEmpty) return;

    for (var element in sentOfferList) {
      if (!itemIdList.contains(element.giveId.toString())) {
        itemIdList.add(element.giveId.toString());
      }
      if (!itemIdList.contains(element.takeId.toString())) {
        itemIdList.add(element.takeId.toString());
      }
    }
    loadSentOfferItems();
  }

  void loadSentOfferItems() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
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

  void refreshSentOffer() {
    sentOfferList.clear();
    itemIdList.clear();
    itemMap.clear();
    loadSentOfferList();
  }

  void deleteOffer(String giveId, String takeId) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/delete_offer.php"),
        body: {
          "giveid": giveId,
          "takeid": takeId,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {}
      setState(() {});
    });
  }

  void loadReceivedOfferList() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_offer.php"),
        body: {
          "useridreceived": widget.user.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['offers'].forEach((v) {
          receivedOfferList.add(Offer.fromJson(v));
        });
        countOffers();
      }
    });
  }

  void countOffers() {
    // Count the occurences of each element
    for (Offer element in receivedOfferList) {
      // See if the element exists in the map,
      // if not, set it to 0 and add it by one
      countMap[element.takeId.toString()] =
          (countMap[element.takeId.toString()] ?? 0) + 1;

      if (!userItemIdList.contains(element.takeId)) {
        userItemIdList.add(element.takeId.toString());
      }
    }
    loadReceivedOfferItems();
  }

  void loadReceivedOfferItems() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {"itemIdList": userItemIdList.toString()}).then((response) {
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

  void refreshReceivedOffer() {
    receivedOfferList.clear();
    userItemList.clear();
    userItemIdList.clear();
    loadReceivedOfferList();
  }
}
