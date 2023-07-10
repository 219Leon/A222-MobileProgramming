import 'package:flutter/material.dart';

import '../../models/user.dart';
import 'package:barterit/models/interest.dart';
import 'package:barterit/models/sharedpref.dart';
import 'searchtabscreen.dart';
import 'homescreen.dart';
import 'barterscreen.dart';
import 'messagestabscreen.dart';
import 'profiletabscreen.dart';

//for buyer screen
//Find Slide Navigation
class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Interest interestLoad = Interest();
  Interest interestSave = Interest();
  SharedPref sharedPref = SharedPref();
  late List<Widget> tabchildren;
  int _currentIndex = 1;
  String maintitle = "Search";

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    // sharedPref.remove(widget.user.id.toString());
    tabchildren = [
      HomeTabScreen(user: widget.user),
      SearchTabScreen(user: widget.user),
      BarterTabScreen(user: widget.user),
      MessagesTabScreen(user: widget.user),
      ProfileTabScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: "Search"),
            BottomNavigationBarItem(
                backgroundColor: Colors.orange,
                icon: Icon(
                  Icons.autorenew,
                ),
                label: "Barter"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Search";
      }
      if (_currentIndex == 2) {
        maintitle = "Barter";
      }
      if (_currentIndex == 3) {
        maintitle = "Messages";
      }
      if (_currentIndex == 4) {
        maintitle = "Profile";
      }
    });
  }

  loadSharedPrefs() async {
    try {
      // sharedPref.remove(widget.user.id.toString());
      // Load user id to look for their search history
      // which is their item interest
      interestLoad =
          Interest.fromJson(await sharedPref.read(widget.user.id.toString()));
    } catch (Exception) {
      // If the user is not found
      interestSave.id = widget.user.id.toString();
      sharedPref.save(widget.user.id.toString(), interestSave);
    }
  }
}
