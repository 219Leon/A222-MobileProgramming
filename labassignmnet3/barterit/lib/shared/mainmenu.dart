import 'package:flutter/material.dart';
import '../../screens/mainscreen.dart';
import '../../model/user.dart';
import '../../model/items.dart';
import 'EnterExitRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/config.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  final Item item;
  const MainMenuWidget({super.key, required this.user, required this.item});
  
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
                    : "${Config.SERVER}/assets/profileimages/imageunknown.jpg",
              ),
            ),
          ),
          ListTile(
              title: const Text('Buyer Page'),
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
              title: const Text('Seller Page'),
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
                          selectedIndex: 2,
                        )));
              }),
          
        ],
      ),
    );
  }
}
