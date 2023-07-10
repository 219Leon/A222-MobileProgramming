import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;

import '../../myconfig.dart';
import 'traderitemdetailscreen.dart';

class FavoriteScreen extends StatefulWidget {
  final User user;

  const FavoriteScreen({super.key, required this.user});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late double screenWidth, screenHeight;
  late int axiscount;
  List<Item> itemList = <Item>[];
  Item singleItem = Item();

  @override
  void initState() {
    super.initState();
    loadfavorites();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Favorites",
              style: TextStyle(color: isDark ? Colors.grey : Colors.white)),
          iconTheme: IconThemeData(color: isDark ? Colors.grey : Colors.white),
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: GridView.count(
                    childAspectRatio: 4 / 5,
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
                              Item singleitem =
                                  Item.fromJson(itemList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          TraderItemDetailScreen(
                                              user: widget.user,
                                              useritem: singleitem,
                                              page: "user"))).then((value) {
                                loadfavorites();
                              });
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: itemList[index].itemImageCount ==
                                              "1"
                                          ? CachedNetworkImage(
                                              width: screenWidth,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                              placeholder: (context, url) =>
                                                  const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )
                                          : itemList[index].itemImageCount ==
                                                  "2"
                                              ? ImageSlideshow(
                                                  width: screenWidth,
                                                  initialPage: 0,
                                                  children: [
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                        fit: BoxFit.cover,
                                                      )
                                                    ])
                                              : ImageSlideshow(
                                                  width: screenWidth,
                                                  initialPage: 0,
                                                  children: [
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-3.png",
                                                        fit: BoxFit.cover,
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
                                          scrollDirection: Axis.horizontal,

                                          child: Text(
                                            itemList[index].itemName.toString(),
                                            style:
                                                const TextStyle(fontSize: 18),
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
                                      Text(
                                        "${itemList[index].itemQty} available",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      },
                    ))),
          ],
        )));
  }

  void loadfavorites() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {"favorite_userid": widget.user.id}).then((response) {
      itemList.clear();

      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          singleItem = Item.fromJson(v);
          itemList.add(singleItem);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No Favorited item(s)")));
        Navigator.pop(context);
      }
      setState(() {});
    });
  }
}
