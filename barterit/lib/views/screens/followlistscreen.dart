import 'dart:convert';

import 'package:barterit/views/screens/traderscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';
import '../../myconfig.dart';

class FollowListScreen extends StatefulWidget {
  final User user;
  final String page;

  const FollowListScreen({super.key, required this.user, required this.page});

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen>
    with SingleTickerProviderStateMixin {
  late double screenHeight, screenWidth;
  late final TabController _tabController = TabController(
      length: 2, vsync: this, initialIndex: widget.page == "following" ? 1 : 0);
  int followers = 0;
  int following = 0;
  bool isFollow = false;
  List<String> unfollowed = <String>[];
  List<User> followerList = <User>[];
  List<User> followingList = <User>[];

  @override
  void initState() {
    super.initState();
    loadfollowers();
    loadfollowing();
    loadfollowerslist();
    loadfollowinglist();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  // This is to check whether user change favorite, if yes, update to server
                  if (unfollowed.isNotEmpty) {
                    for (var element in unfollowed) {
                      unfollow(element);
                    }
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              widget.user.name.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                tabs: [
                  Tab(text: '$followers followers'),
                  Tab(
                    text: '$following following',
                  )
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Center(
                child: Column(
                  children: [
                    if (followerList.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            itemCount: followerList.length,
                            itemBuilder: (context, index) {
                              final user = followerList[index];

                              return GestureDetector(
                                onTap: () {
                                  if (unfollowed.isNotEmpty) {
                                    for (var element in unfollowed) {
                                      unfollow(element);
                                    }
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => TraderScreen(
                                              user: widget.user,
                                              trader: user))).then((value) {
                                    followingList.clear();
                                    unfollowed.clear();
                                    loadfollowing();
                                    loadfollowinglist();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundImage: user
                                                      .hasavatar
                                                      .toString() ==
                                                  "1"
                                              ? NetworkImage(
                                                  "${MyConfig().SERVER}/barterit/assets/avatars/${user.id}.png")
                                              : NetworkImage(
                                                  "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                                      const SizedBox(width: 14),
                                      Text(
                                        user.name.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: isDark
                                                  ? Colors.grey[800]
                                                  : Colors.grey[300]),
                                          onPressed: () {
                                            removefollowDialog(index);
                                          },
                                          child: Text(
                                            "Remove",
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    if (followingList.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: followingList.length,
                            itemBuilder: (context, index) {
                              final user = followingList[index];

                              return GestureDetector(
                                onTap: () {
                                  if (unfollowed.isNotEmpty) {
                                    for (var element in unfollowed) {
                                      unfollow(element);
                                    }
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => TraderScreen(
                                              user: widget.user,
                                              trader: user))).then((value) {
                                    followingList.clear();
                                    unfollowed.clear();
                                    loadfollowing();
                                    loadfollowinglist();
                                    setState(() {});
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundImage: user
                                                      .hasavatar
                                                      .toString() ==
                                                  "1"
                                              ? NetworkImage(
                                                  "${MyConfig().SERVER}/barterit/assets/avatars/${user.id}.png")
                                              : NetworkImage(
                                                  "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                                      const SizedBox(width: 14),
                                      Text(
                                        user.name.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      if (!unfollowed
                                          .contains(user.id.toString()))
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: isDark
                                                    ? Colors.grey[800]
                                                    : Colors.grey[300]),
                                            onPressed: () {
                                              unfollowed
                                                  .add(user.id.toString());
                                              following--;
                                              setState(() {});
                                            },
                                            child: Text(
                                              "Following",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                            )),
                                      if (unfollowed
                                          .contains(user.id.toString()))
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: isDark
                                                    ? Colors.white
                                                    : Colors.orange),
                                            onPressed: () {
                                              unfollowed
                                                  .remove(user.id.toString());
                                              following++;
                                              setState(() {});
                                            },
                                            child: Text("Follow",
                                                style: TextStyle(
                                                    color: isDark
                                                        ? Colors.black
                                                        : Colors.white))),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                  ],
                ),
              )
            ],
          )),
    );
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

  // Save list of followers who followed the user
  void loadfollowerslist() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "list_traderid": widget.user.id,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['users'].forEach((v) {
          followerList.add(User.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  // Save list of traders which followed by the user
  void loadfollowinglist() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "list_userid": widget.user.id,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        print("success");
        var extractdata = jsondata['data'];
        extractdata['users'].forEach((v) {
          followingList.add(User.fromJson(v));
        });
      } else {
        print("failed");
      }
      setState(() {});
    });
  }

  void removefollowDialog(int index) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "Remove ${followerList[index].name}?",
            ),
            content: Text(
                "We won't tell ${followerList[index].name} that they were removed from your followers.",
                style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700])),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  removefollow(index);
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

  void removefollow(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/manage_follow.php"),
        body: {
          "deleteuserid": followerList[index].id,
          "deletetraderid": widget.user.id,
        }).then((response) {
      followerList.clear();
      loadfollowers();
      loadfollowerslist();
      setState(() {});
    });
  }

  void unfollow(String traderid) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/manage_follow.php"),
        body: {
          "deleteuserid": widget.user.id,
          "deletetraderid": traderid,
        });
  }
}
