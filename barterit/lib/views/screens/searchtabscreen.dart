import 'package:barterit/views/screens/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/widgets/searchitemwidget.dart';

class SearchTabScreen extends StatefulWidget {
  final User user;
  const SearchTabScreen({super.key, required this.user});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  String maintitle = "Search";
  final TextEditingController _searchitemEditingController =
      TextEditingController();
  late double screenWidth, screenHeight;

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          title: Text(maintitle, style: const TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                      screenHeight * 0.03, screenWidth * 0.05, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Search for an item",
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.03,
                      screenWidth * 0.05,
                      screenHeight * 0.05),
                  child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty
                          ? "Please provide input for searching items"
                          : null,
                      onFieldSubmitted: (v) {
                        if (v.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => SearchScreen(
                                      user: widget.user, search: v)));
                        }
                      },
                      maxLines: 1,
                      controller: _searchitemEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'eg: Television',
                        labelStyle: const TextStyle(),
                        prefixIcon: const Icon(Icons.search),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                ),
                //Card Selections: 1st Row
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0,
                      screenWidth * 0.05, screenHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Electronic Devices")));
                          },
                          child: const SearchItemWidget(Colors.blue,
                              Icons.devices, "Electronic Devices")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Vehicles")));
                          },
                          child: SearchItemWidget(Colors.purple.shade300,
                              Icons.car_rental, "Vehicles")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Furniture & Accessories")));
                          },
                          child: const SearchItemWidget(Colors.orange,
                              Icons.table_bar, "Furniture & Accessories"))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0,
                      screenWidth * 0.05, screenHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Books & Stationery")));
                          },
                          child: SearchItemWidget(Colors.green.shade300,
                              Icons.book, "Books & Stationery")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Home Appliances")));
                          },
                          child: const SearchItemWidget(
                              Colors.grey, Icons.blender, "Home Appliances")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Fashion & Cosmetics")));
                          },
                          child: SearchItemWidget(Colors.pinkAccent.shade100,
                              Icons.face, "Fashion & Cosmetics"))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0,
                      screenWidth * 0.05, screenHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Games & Consoles")));
                          },
                          child: const SearchItemWidget(Colors.greenAccent,
                              Icons.games, "Video Game \n& Consoles")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "For Children")));
                          },
                          child: SearchItemWidget(Colors.orange.shade300,
                              Icons.child_care, "For Children")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Musical Instruments")));
                          },
                          child: SearchItemWidget(Colors.blue.shade300,
                              Icons.music_note, "Musical Instruments"))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user, search: "Sports")));
                          },
                          child: SearchItemWidget(
                              Colors.red.shade200, Icons.run_circle, "Sports")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user,
                                        search: "Food & Nutrition")));
                          },
                          child: SearchItemWidget(Colors.red.shade300,
                              Icons.food_bank, "Food & Nutrition")),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SearchScreen(
                                        user: widget.user, search: "Other")));
                          },
                          child: const SearchItemWidget(
                              Colors.black38, Icons.question_mark, "Other"))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
