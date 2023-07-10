import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../myconfig.dart';
import 'traderitemdetailscreen.dart';

class TraderScreen extends StatefulWidget {
  final User user;
  final User trader;

  const TraderScreen({super.key, required this.user, required this.trader});

  @override
  State<TraderScreen> createState() => _TraderScreenState();
}

class _TraderScreenState extends State<TraderScreen> {
  List<Item> itemList = <Item>[];
  late double screenWidth, screenHeight;
  bool isLoading = false;
  bool hasMore = true;
  bool isFollow = false;
  int limit = 10;
  int offset = 0;
  int posts = 0;
  int axiscount = 2;
  int following = 0;
  int followers = 0;
  final df = DateFormat('d MMM');

  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // This is to load items in the database
      loaduseritems();
      loadfollow();
      loadfollowers();
      loadfollowing();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
              style: const TextStyle(color: Colors.white),
              widget.trader.name.toString()),
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Center(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: screenHeight * 0.17,
                width: screenWidth,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Profile picture
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          CircleAvatar(
                              radius: screenHeight * 0.05,
                              backgroundImage: widget.trader.hasavatar
                                          .toString() ==
                                      "1"
                                  ? NetworkImage(
                                      "${MyConfig().SERVER}/barterit/assets/avatars/${widget.trader.id}.png?")
                                  : NetworkImage(
                                      "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                          const SizedBox(height: 10),
                          if (!isFollow)
                            InkWell(
                                child: const Text(
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                    "Follow"),
                                onTap: () async {
                                  await followTrader();
                                  loadfollowers();
                                  setState(() {});
                                }),
                          if (isFollow)
                            InkWell(
                                child: const Text(
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                    "Following"),
                                onTap: () async {
                                  unfollowDialog();
                                  setState(() {});
                                }),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(posts.toString()),
                          Text(
                            "Posts",
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(followers.toString()),
                          Text(
                            "Followers",
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(following.toString()),
                          Text("Following",
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey))
                        ],
                      ),
                    ]),
              ),
              Divider(
                  indent: 8,
                  endIndent: 8,
                  color: isDark ? Colors.grey[400] : Colors.black),
              const SizedBox(height: 8),
              Expanded(
                  child: itemList.isEmpty
                      ? const Text(
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                          "No items added for barter :(")
                      : GridView.count(
                          shrinkWrap: true,
                          childAspectRatio: 5 / 6,
                          crossAxisCount: axiscount,
                          children: List.generate(
                            itemList.length,
                            (index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 2,
                                  child: InkWell(
                                    onTap: () async {
                                      Item singleitem = Item.fromJson(
                                          itemList[index].toJson());
                                      await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (content) =>
                                                      TraderItemDetailScreen(
                                                          user: widget.user,
                                                          useritem: singleitem,
                                                          page: "trader")))
                                          .then((value) {
                                        itemList.clear();
                                        offset = 0;
                                        loaduseritems();
                                      });
                                    },
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                              child: itemList[index]
                                                          .itemImageCount ==
                                                      "1"
                                                  ? CachedNetworkImage(
                                                      width: screenWidth,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                      placeholder: (context,
                                                              url) =>
                                                          const LinearProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    )
                                                  : itemList[index]
                                                              .itemImageCount ==
                                                          "2"
                                                      ? ImageSlideshow(
                                                          width: screenWidth,
                                                          initialPage: 0,
                                                          children: [
                                                              Image.network(
                                                                "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Image.network(
                                                                "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            ])
                                                      : ImageSlideshow(
                                                          width: screenWidth,
                                                          initialPage: 0,
                                                          children: [
                                                              Image.network(
                                                                "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Image.network(
                                                                "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Image.network(
                                                                "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-3.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ])),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  // for horizontal scrolling
                                                  scrollDirection:
                                                      Axis.horizontal,

                                                  child: Text(
                                                    itemList[index]
                                                        .itemName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              // Add fovorite icon in here later
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth * 0.25,
                                                    child: Text(
                                                      "${itemList[index].itemLocality} - ${itemList[index].itemState}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.25,
                                                    child: Text(
                                                      df.format(DateTime.parse(
                                                          itemList[index]
                                                              .itemDate
                                                              .toString())),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.orange),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: screenWidth * 0.2,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Adjust the border radius as needed
                                                  color: isDark
                                                      ? Colors.black54
                                                      : Colors.grey[
                                                          300], // Background color of the rounded rectangle
                                                ),
                                                padding: const EdgeInsets.all(
                                                    5.0), // Adjust the padding as needed
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Same border radius as the container
                                                  child: Text(
                                                    'RM ${double.parse(itemList[index].itemPrice.toString())}',
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ]),
                                  ));
                            },
                          )))
            ],
          )),
        ));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      offset = 0;
      itemList.clear();
    });

    loaduseritems();
  }

  void loaduseritems() {
    if (widget.trader.id == "na") {
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {
          "userid": widget.trader.id,
          "limit": limit.toString(),
          "offset": offset.toString()
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        posts = jsondata['posts'];
        extractdata['items'].forEach((v) {
          itemList.add(Item.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  // This is triggered when user follow the trader
  Future followTrader() async {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/manage_follow.php"),
        body: {
          "userid": widget.user.id,
          "traderid": widget.trader.id,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          setState(() {
            isFollow = true;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Follow Success")));
          loadfollowers();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  // This is to calculate the number of followers
  void loadfollowers() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "traderid": widget.trader.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        followers = jsondata['follow'];
      }
      setState(() {});
    });
  }

  // This is to calculate the number trader the user is following
  void loadfollowing() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "userid": widget.trader.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        following = jsondata['follow'];
      } else {
        following = 0;
      }
      setState(() {});
    });
  }

  // This is to check whether the user follows this trader
  void loadfollow() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "userid": widget.user.id,
          "traderid": widget.trader.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        isFollow = true;
      } else {
        isFollow = false;
      }
      setState(() {});
    });
  }

  void unfollowDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "Unfollow ${widget.trader.name}?",
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
                  unfollow();
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
        });
  }

  void unfollow() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/manage_follow.php"),
        body: {
          "deleteuserid": widget.user.id,
          "deletetraderid": widget.trader.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        isFollow = false;
        followers--;
      } else {
        isFollow = true;
      }
      setState(() {});
    });
  }
}
