import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/mainscreen.dart';
import '../../model/user.dart';
import '../../model/items.dart';
import '../screens/loginscreen.dart';
import 'EnterExitRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/config.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  get transaction => null;

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.email.toString()),
            accountEmail: Text(widget.user.name.toString()),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundImage: CachedNetworkImageProvider(
                widget.user.id != null
                    ? "${Config.SERVER}/assets/profileimages/${widget.user.id}.jpg"
                    : "${Config.SERVER}/assets/profileimages/0.jpg",
              ),
            ),
          ),
          ListTile(
              title: const Text('List of Owned Items'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 0,
                        ),
                        enterPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 1,
                        )));
              }),
          ListTile(
              title: const Text('Search for Available Items'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 0,
                        ),
                        enterPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 0,
                        )));
              }),
              ListTile(
              title: const Text('Barter History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 0,
                        ),
                        enterPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 2,
                        )));
              }),
          ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 0,
                        ),
                        enterPage: MainScreen(
                          user: widget.user,
                          selectedIndex: 3,
                        )));
              }),
          if (widget.user.id == "0") // Condition for user ID equals "0"
            ListTile(
              title: const Text('Login/Register'),
              onTap: () {
                 Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
              },
            )
          else
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                () async {
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
                };
              },
            ),
        ],
      ),
    );
  }
}
