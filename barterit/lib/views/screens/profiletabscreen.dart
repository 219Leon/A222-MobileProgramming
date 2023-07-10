import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:barterit/views/experiment.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:barterit/views/screens/newtradescreen.dart';
import 'package:barterit/views/screens/purchasecreditscreen.dart';
import 'package:barterit/views/screens/favoritescreen.dart';
import 'package:barterit/views/screens/loginscreen.dart';
import 'package:barterit/views/screens/useritemdetailscreen.dart';
import 'package:barterit/myconfig.dart';
import 'package:ndialog/ndialog.dart';
import 'package:barterit/main.dart';
import 'package:intl/intl.dart';

import 'followlistscreen.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;
  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late List<Widget> tabchildren;
  late int axiscount = 2;
  late int val;
  late double screenHeight, screenWidth, cardwitdh;
  String maintitle = "Profile";
  String avatarPath = "assets/images/profile-placeholder.png";
  int limit = 10;
  int offset = 0;
  int posts = 0;
  int followers = 0;
  int following = 0;
  bool isLoading = false;
  bool hasMore = true;
  bool gotFavorite = false;
  bool imageExist = false;
  File? _image;
  DateTime now = DateTime.now();
  Random random = Random();
  List<Item> itemList = <Item>[];
  final df = DateFormat('d MMM');

  @override
  void initState() {
    super.initState();
    // The val below is for profile picture function, randomly generate number for system to update to newest profile pic
    val = random.nextInt(10000);
    Future.delayed(Duration.zero, () {
      checkLogin();
      loadfavorites();
      // This is to load items in the database
      loaduseritems();

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
        //The app bar will have different layout based on whether user logged into the system
        appBar: widget.user.id.toString() != "na"
            ? AppBar(
                title: Text(
                    style: const TextStyle(color: Colors.white),
                    widget.user.name.toString()),
                actions: [
                  PopupMenuButton<int>(
                      onSelected: (item) => onSelected(context, item),
                      itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Profile')),
                            PopupMenuItem<int>(
                              value: 1,
                              child: isDark
                                  ? const Text('LightMode')
                                  : const Text('DarkMode'),
                            ),
                            const PopupMenuItem<int>(
                              value: 2,
                              child: Text('Logout'),
                            ),
                          ])
                ],
              )
            : AppBar(
                title: Text(maintitle),
              ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  height: screenHeight * 0.18,
                  width: screenWidth,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            // Profile picture
                            CircleAvatar(
                                radius: screenHeight * 0.05,
                                backgroundImage: widget.user.hasavatar
                                            .toString() ==
                                        "1"
                                    ? NetworkImage(
                                        "${MyConfig().SERVER}/barterit/assets/avatars/${widget.user.id}.png?v=$val")
                                    : NetworkImage(
                                        "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),

                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            PurchaseCreditScreen(
                                              user: widget.user,
                                            ))).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add_circle,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    "  ${widget.user.credit.toString()}",
                                  )
                                ],
                              ),
                            )
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => FollowListScreen(
                                        user: widget.user,
                                        page: "follower"))).then((value) {
                              setState(() {
                                loadfollowers();
                                loadfollowing();
                              });
                            });
                          },
                          child: Column(
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
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => FollowListScreen(
                                        user: widget.user,
                                        page: "following"))).then((value) {
                              setState(() {
                                loadfollowers();
                                loadfollowing();
                              });
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(following.toString()),
                              Text("Following",
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey))
                            ],
                          ),
                        ),
                      ]),
                ),

                // This is just design to seperate profile information with item information
                Divider(
                    indent: 8,
                    endIndent: 8,
                    color: isDark ? Colors.grey[400] : Colors.black87),
                // Options to edit avatar or see favorited items
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05, 4, screenWidth * 0.05, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          child: const Text(
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                              "Edit Avatar"),
                          onTap: () {
                            _selectFromGallery();
                          }),
                      InkWell(
                        child: const Text(
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                            "Favorites"),
                        onTap: () {
                          if (gotFavorite) {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            FavoriteScreen(user: widget.user)))
                                .then((value) {
                              offset = 0;
                              itemList.clear();
                              loaduseritems();
                              loadfavorites();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("No Favorited item(s)")));
                          }
                        },
                      )
                    ],
                  ),
                ),
                Container(
                    child: itemList.isEmpty
                        ? Column(
                            children: [
                              const Text(
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                  "No items added for barter :("),
                              SizedBox(height: screenHeight * 0.08),
                              Padding(
                                padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                                    0, screenWidth * 0.05, 0),
                                child: const Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                    "As a start!😆\nLook for items that you don't need or bored from at your home and add them to your barter list. Then you can trade with others!"),
                              ),
                            ],
                          )
                        : GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 5 / 6,
                            crossAxisCount: axiscount,
                            children: List.generate(
                              itemList.length,
                              (index) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 2,
                                    child: InkWell(
                                      onLongPress: () {
                                        onDeleteDialog(index);
                                      },
                                      onTap: () async {
                                        Item singleitem = Item.fromJson(
                                            itemList[index].toJson());
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (content) =>
                                                    UserItemDetailScreen(
                                                        user: widget.user,
                                                        useritem: singleitem,
                                                        page: "user"))).then(
                                            (value) {
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
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                                colorFilter: const ColorFilter
                                                                        .mode(
                                                                    Colors
                                                                        .white,
                                                                    BlendMode
                                                                        .colorBurn)),
                                                          ),
                                                        ),
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.25,
                                                      child: Text(
                                                        df.format(DateTime
                                                            .parse(itemList[
                                                                    index]
                                                                .itemDate
                                                                .toString())),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.orange),
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
              ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor:
                isDark ? Colors.white : Theme.of(context).primaryColor,
            onPressed: () {
              if (widget.user.id != "na") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => NewTradeScreen(
                              user: widget.user,
                            ))).then((value) {
                  itemList.clear();
                  offset = 0;
                  loaduseritems();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
              }
            },
            child: Text(
              "+",
              style: TextStyle(
                  fontSize: 32, color: isDark ? Colors.black87 : Colors.white),
            )));
  }

  Future<void> _pullRefresh() async {
    Future refresh() async {
      setState(() {
        isLoading = false;
        hasMore = true;
        offset = 0;
        itemList.clear();
      });

      loaduseritems();
    }
  }

  void checkLogin() {
    print(widget.user.email);
    if (widget.user.id == "na") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Login Required",
              style: TextStyle(),
            ),
            content: const Text(
              textAlign: TextAlign.center,
              "Kindly login to use\nbarterit services",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child:
                      const Text("Next", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => Experiment(
                      user: widget.user,
                      useritem: itemList[0],
                      page: "",
                    ))).then((value) {
          setState(() {
            loadfollowers();
            loadfollowing();
          });
        });

        break;
      case 1:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool themeValue = prefs.getBool('theme') ?? true;
        setState(() {
          if (themeValue == true) {
            MyAppState.themeManager.toggleTheme(false);
            prefs.setBool('theme', false);
          } else {
            MyAppState.themeManager.toggleTheme(true);
            prefs.setBool('theme', true);
          }
        });

        break;
      case 2:
        print('Clicked Logout');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen()));

        break;
    }
  }

  Future<void> _selectFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No Image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: _image!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      // CropAspectRatioPreset.ratio3x2,
      // CropAspectRatioPreset.original,
      // CropAspectRatioPreset.ratio4x3,
      // CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.orangeAccent,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: 'Cropper',
      )
    ]);

    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);
      insertAvatar();
      setState(() {
        val++;
        imageExist = true;
      });
    }
  }

  void insertAvatar() {
    String base64Image = base64Encode(_image!.readAsBytesSync());
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text("Processing..."),
        message: const Text("Updating your Profile Picture"));
    progressDialog.show();
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/insert_avatar.php"),
        body: {
          "user_id": widget.user.id.toString(),
          "image": base64Image,
        }).then((response) {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      progressDialog.dismiss();
    });

    if (widget.user.hasavatar == "0") widget.user.hasavatar = "1";
  }

  void loaduseritems() {
    if (widget.user.id == "na") {
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {
          "userid": widget.user.id,
          "limit": limit.toString(),
          "offset": offset.toString()
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];

        // get number of post under the user
        posts = jsondata['posts'];

        // assign the items into itemList as objects
        extractdata['items'].forEach((v) {
          itemList.add(Item.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
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

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loaduseritems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  Future loadfavorites() async {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {"favorite_userid": widget.user.id}).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        gotFavorite = true;
      } else {
        gotFavorite = false;
      }
    });
  }

  // This is to calculate the number of followers
  void loadfollowers() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "traderid": widget.user.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        followers = jsondata['follow'];
      } else {
        followers = 0;
      }
      setState(() {});
    });
  }

  // This is to calculate the number trader the user is following
  void loadfollowing() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "userid": widget.user.id,
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
}
