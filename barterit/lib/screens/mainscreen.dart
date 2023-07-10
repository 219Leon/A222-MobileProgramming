import 'package:barterit/screens/searchscreen.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

import 'homescreen.dart';
import 'barterscreen.dart';
import 'profiletabscreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class MainScreen extends StatefulWidget {
  final User user;
  var selectedIndex;

 MainScreen(
      {super.key,
      required this.selectedIndex,
      required this.user,
      });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _tabs = [
      HomeScreen(user: widget.user, selectedIndex: 0),
      SearchScreen(user: widget.user, selectedIndex: 1),
      BarterScreen(user:widget.user, selectedIndex: 2),
      ProfileScreen(user: widget.user, selectedIndex: 3)
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
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 15),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              curve: Curves.easeOutExpo,
              gap: 10,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              activeColor: Colors.teal,
              tabBorder: Border.all(color: Colors.tealAccent),
              tabActiveBorder: Border.all(),
              tabBorderRadius: 30,
              iconSize: 20,
              tabBackgroundColor: Colors.teal.withOpacity(0.1),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.autorenew,
                  text: 'Barter',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
