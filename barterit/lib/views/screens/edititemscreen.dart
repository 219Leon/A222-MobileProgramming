import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/barterto.dart';
import 'package:barterit/views/screens/bartertoscreen.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../../myconfig.dart';

class ImageConfig {
  String source = "";
  String path = "";

  ImageConfig({required this.source, required this.path});
}

class EditItemScreen extends StatefulWidget {
  final User user;
  final Item useritem;

  const EditItemScreen({super.key, required this.user, required this.useritem});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  int selected = 0;
  late BarterTo isSelected = BarterTo(
      selected: 0,
      electDevice: false,
      vehicle: false,
      furniture: false,
      bookStation: false,
      homeAppliance: false,
      fashionCosmetic: false,
      gameConsole: false,
      forChildren: false,
      musicalInstrument: false,
      sport: false,
      foodNutrition: false,
      other: false);
  List<String> barterto = [];

  String stringValidation = "";
  bool imgCheck = false;
  String pathAsset = "assets/images/no-photo.png";
  late List<ImageConfig> imgList;
  List<Widget>? imageSliders;

  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardWidth;
  final TextEditingController _itemnameEditingController =
      TextEditingController();
  final TextEditingController _itemdescEditingController =
      TextEditingController();
  final TextEditingController _itemqtyEditingController =
      TextEditingController();
  final TextEditingController _itempriceEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  String selectedType = "Electronic Devices";
  List<String> itemList = [
    "Electronic Devices",
    "Vehicles",
    "Furniture & Accessories",
    "Books & Stationery",
    "Home Appliances",
    "Fashion & Cosmetics",
    "Games & Consoles",
    "For Children",
    "Musical Instruments",
    "Sports",
    "Food & Nutrition",
    "Other",
  ];

  @override
  void initState() {
    super.initState();

    fetchBarterto();
    fetchitemData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title:
              const Text(style: TextStyle(color: Colors.white), "Edit Item")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          CarouselSlider.builder(
              itemCount: imgList.length,
              options: CarouselOptions(height: screenHeight * 0.35),
              itemBuilder: (context, index, realIndex) {
                var imgItem = imgList[index];
                return buildImage(imgItem, index);
              }),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                        maxLength: 30,
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Item name must be longer than 3"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _itemnameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.abc),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          height: 65,
                          child: DropdownButton(
                            value: widget.useritem.itemType,
                            onChanged: (newValue) {
                              setState(() {
                                widget.useritem.itemType = newValue!;
                              });
                            },
                            items: itemList.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity should be at least 1"
                                  : null,
                              controller: _itemqtyEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.numbers),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: screenHeight > 750 ? 4 : 3,
                        controller: _itemdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        maxLength: 5,
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 2)
                            ? "Price cannot be empty"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _itempriceEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Total Price',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.currency_pound),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _prstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current States',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            )),
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current Locality"
                                        : null,
                                controller: _prlocalEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current Locality',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.map),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )))),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Barter Section: ",
                            style: Theme.of(context).textTheme.titleLarge)),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("- Add what item type you want barter to: ",
                            style: Theme.of(context).textTheme.titleSmall)),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? const Color.fromARGB(255, 145, 70, 70)
                                : Colors.red[400]),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => BarterToScreen(
                                        user: widget.user,
                                        isSelected: isSelected,
                                      ))).then((value) {
                            BoxedReturns box = value;
                            // fetch the isSelected object from BarterTo
                            setState(() {
                              isSelected = box.isSelected;
                              barterto.addAll(box.barterto);
                              print(barterto.toString());
                            });
                            // loaduseritems();
                          });
                        },
                        child: Text(
                          "Add Barter Categories",
                          style: isDark
                              ? TextStyle(color: Colors.red[100])
                              : const TextStyle(color: Colors.white),
                        )),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      children: [
                        if (isSelected.electDevice)
                          Chip(
                              label: const Text("Electronic Devices"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.electDevice = false;
                                  barterto.remove("Electronic Devices");
                                });
                              }),
                        if (isSelected.vehicle)
                          Chip(
                              label: const Text("Vehicles"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.vehicle = false;
                                  barterto.remove("Vehicles");
                                });
                              }),
                        if (isSelected.furniture)
                          Chip(
                              label: const Text("Furniture & Accessories"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.furniture = false;
                                  barterto.remove("Furniture & Accessories");
                                });
                              }),
                        if (isSelected.bookStation)
                          Chip(
                              label: const Text("Books & Stationery"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.bookStation = false;
                                  barterto.remove("Books & Stationery");
                                });
                              }),
                        if (isSelected.homeAppliance)
                          Chip(
                              label: const Text("Home Appliances"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.homeAppliance = false;
                                  barterto.remove("Home Appliances");
                                });
                              }),
                        if (isSelected.fashionCosmetic)
                          Chip(
                              label: const Text("Fashion & Cosmetics"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.fashionCosmetic = false;
                                  barterto.remove("Fashion & Cosmetics");
                                });
                              }),
                        if (isSelected.gameConsole)
                          Chip(
                              label: const Text("Video Game & Consoles"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.gameConsole = false;
                                  barterto.remove("Video Game & Consoles");
                                });
                              }),
                        if (isSelected.forChildren)
                          Chip(
                              label: const Text("For Children"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.forChildren = false;
                                  barterto.remove("For Children");
                                });
                              }),
                        if (isSelected.musicalInstrument)
                          Chip(
                              label: const Text("Musical Instruments"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.musicalInstrument = false;
                                  barterto.remove("Musical Instruments");
                                });
                              }),
                        if (isSelected.sport)
                          Chip(
                              label: const Text("Sports"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.sport = false;
                                  barterto.remove("Sports");
                                });
                              }),
                        if (isSelected.foodNutrition)
                          Chip(
                              label: const Text("Food & Nutrition"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.foodNutrition = false;
                                  barterto.remove("Food & Nutrition");
                                });
                              }),
                        if (isSelected.other)
                          Chip(
                              label: const Text("Other"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.white : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.other = false;
                                  barterto.remove("Other");
                                });
                              }),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text(
                              style: TextStyle(color: Colors.white),
                              "Update Item")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildImage(ImageConfig imgItem, int index) => GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image cannot be edited")));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.grey,
          child: imgItem.source == "asset"
              ? Image.asset(pathAsset)
              : imgItem.source == "file"
                  ? Image.file(File(imgItem.path),
                      fit: BoxFit.cover, width: screenWidth * 0.8)
                  : Image.network(imgItem.path,
                      fit: BoxFit.cover, width: screenWidth * 0.8),
        ),
      );

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    // Check whether there are image to be uploaded
    for (var element in imgList) {
      if (element.source == "file" || element.source == "network") {
        imgCheck = true;
        break;
      } else {
        imgCheck = false;
      }
    }

    if (imgCheck == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please take at least one picture")));
      return;
    }
    if (isSelected.selected == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select at least one barter category")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop(isSelected);
                updateItem();
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

  void updateItem() {
    widget.useritem.itemName = _itemnameEditingController.text;
    widget.useritem.itemDesc = _itemdescEditingController.text;
    widget.useritem.itemQty = _itemqtyEditingController.text;
    widget.useritem.itemPrice = _itempriceEditingController.text;
    widget.useritem.itemBarterto = barterto.toString();

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/update_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": widget.useritem.itemId,
          "itemname": widget.useritem.itemName,
          "itemprice": widget.useritem.itemPrice,
          "itemdesc": widget.useritem.itemDesc,
          "itemqty": widget.useritem.itemQty,
          "type": widget.useritem.itemType,
          "barterto": barterto.toString(),
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }

  void fetchBarterto() {
    if (widget.useritem.itemBarterto!.contains("Electronic Devices")) {
      barterto.add("Electronic Devices");
      isSelected.electDevice = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Vehicles")) {
      barterto.add("Vehicles");
      isSelected.vehicle = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Furniture & Accessories")) {
      barterto.add("Furniture & Accessories");
      isSelected.furniture = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Books & Stationery")) {
      barterto.add("Books & Stationery");
      isSelected.bookStation = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Home Appliances")) {
      barterto.add("Home Appliances");
      isSelected.homeAppliance = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Fashion & Cosmetics")) {
      barterto.add("Fashion & Cosmetics");
      isSelected.fashionCosmetic = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Video Game & Consoles")) {
      barterto.add("Video Game & Consoles");
      isSelected.gameConsole = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("For Children")) {
      barterto.add("For Children");
      isSelected.forChildren = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Musical Instruments")) {
      barterto.add("Musical Instruments");
      isSelected.musicalInstrument = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Sports")) {
      barterto.add("Sports");
      isSelected.sport = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Food & Nutrition")) {
      barterto.add("Food & Nutrition");
      isSelected.foodNutrition = true;
      isSelected.selected++;
    }

    if (widget.useritem.itemBarterto!.contains("Other")) {
      barterto.add("Other");
      isSelected.other = true;
      isSelected.selected++;
    }
  }

  void fetchitemData() {
    // fetch image(s)
    // get the amount of image in the item
    int imgCount = int.parse(widget.useritem.itemImageCount.toString());

    List<ImageConfig> temp = [];
    if (imgCount == 1) {
      for (int i = 0; i < imgCount + 1; i++) {
        temp.add(
            ImageConfig(source: "asset", path: "assets/images/no-photo.png"));
      }
    } else {
      for (int i = 0; i < imgCount; i++) {
        temp.add(
            ImageConfig(source: "asset", path: "assets/images/no-photo.png"));
      }
    }

    // Assign temporary list to imgList
    imgList = temp;

    //assigning these image into carousel
    for (int i = 0; i < imgCount; i++) {
      ImageConfig imgItem = ImageConfig(
          source: "network",
          path:
              "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-${i + 1}.png");
      imgList[i] = imgItem;
    }

    // fetch item name
    _itemnameEditingController.text = widget.useritem.itemName.toString();

    // fetch quantity
    _itemqtyEditingController.text = widget.useritem.itemQty.toString();

    //fetch item price
    _itempriceEditingController.text = widget.useritem.itemPrice.toString();

    // fetch description
    _itemdescEditingController.text = widget.useritem.itemDesc.toString();

    //fetch location data
    _prlocalEditingController.text = widget.useritem.itemLocality.toString();
    _prstateEditingController.text = widget.useritem.itemState.toString();
  }
}
