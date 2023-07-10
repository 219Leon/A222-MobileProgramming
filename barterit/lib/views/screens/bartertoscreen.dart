import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/barterto.dart';
// import 'package:barterit/widgets/bartertoselectedwidget.dart';
// import 'package:barterit/widgets/bartertowidget.dart';

class BoxedReturns{
    final BarterTo isSelected;
    final List<String> barterto;

    BoxedReturns(this.isSelected, this.barterto);
}

// ignore: must_be_immutable
class BarterToScreen extends StatefulWidget {
  final User user;
  BarterTo isSelected;

  BarterToScreen({super.key, required this.user, required this.isSelected});

  @override
  State<BarterToScreen> createState() => _BarterToScreenState();
}

class _BarterToScreenState extends State<BarterToScreen> {
  late double screenHeight, screenWidth;
  int limit = 5;
  List<String> barterto = [];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
          child: Column(
        children: [
          SizedBox(height: screenHeight * 0.07),
          Padding(
            padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05, 0, screenWidth * 0.05, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Barter Category",
                    style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: isDark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                    onPressed: () {
                      // pass isSelected back to TradeScreen
                      Navigator.of(context).pop(BoxedReturns(
                        widget.isSelected, barterto));
                    },
                    child: Text(
                      "   Done   ",
                      style: isDark
                          ? TextStyle(color: Colors.grey[700])
                          : const TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
          const Text("You can select up to 5 item categories! Add them up! 😎"),
          const SizedBox(height: 20),
          Wrap(
            spacing: 5,
            children: [
              if (widget.isSelected.electDevice)
                Chip(
                    label: const Text("Electronic Devices"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.electDevice = false;
                        barterto.remove("Electronic Devices");
                      });
                    }),
              if (widget.isSelected.vehicle)
                Chip(
                    label: const Text("Vehicles"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.vehicle = false;
                        barterto.remove("Vehicles");
                      });
                    }),
              if (widget.isSelected.furniture)
                Chip(
                    label: const Text("Furniture & Accessories"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.furniture = false;
                        barterto.remove("Furniture & Accessories");
                      });
                    }),
              if (widget.isSelected.bookStation)
                Chip(
                    label: const Text("Books & Stationery"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.bookStation = false;
                        barterto.remove("Books & Stationery");
                      });
                    }),
              if (widget.isSelected.homeAppliance)
                Chip(
                    label: const Text("Home Appliances"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.homeAppliance = false;
                        barterto.remove("Home Appliances");
                      });
                    }),
              if (widget.isSelected.fashionCosmetic)
                Chip(
                    label: const Text("Fashion & Cosmetics"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.fashionCosmetic = false;
                        barterto.remove("Fashion & Cosmetics");
                      });
                    }),
              if (widget.isSelected.gameConsole)
                Chip(
                    label: const Text("Video Game & Consoles"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.gameConsole = false;
                        barterto.remove("Video Game & Consoles");
                      });
                    }),
              if (widget.isSelected.forChildren)
                Chip(
                    label: const Text("For Children"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.forChildren = false;
                        barterto.remove("For Children");
                      });
                    }),
              if (widget.isSelected.musicalInstrument)
                Chip(
                    label: const Text("Musical Instruments"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.musicalInstrument = false;
                        barterto.remove("Musical Instruments");
                      });
                    }),
              if (widget.isSelected.sport)
                Chip(
                    label: const Text("Sports"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.sport = false;
                        barterto.remove("Sports");
                      });
                    }),
              if (widget.isSelected.foodNutrition)
                Chip(
                    label: const Text("Food & Nutrition"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.foodNutrition = false;
                        barterto.remove("Food & Nutrition");
                      });
                    }),
              if (widget.isSelected.other)
                Chip(
                    label: const Text("Other"),
                    deleteIcon: Icon(Icons.cancel,
                        color: isDark ? Colors.white : Colors.red[400]),
                    onDeleted: () {
                      setState(() {
                        widget.isSelected.selected--;
                        widget.isSelected.other = false;
                        barterto.remove("Other");
                      });
                    }),
            ],
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: widget.isSelected.electDevice ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Electronic Devices");
                            setState(() {
                              widget.isSelected.electDevice = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Electronic Devices",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Electronic Devices");
                            setState(() {
                              widget.isSelected.electDevice = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.vehicle ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Vehicles");
                            setState(() {
                              widget.isSelected.vehicle = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Vehicles",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Vehicles");
                            setState(() {
                              widget.isSelected.vehicle = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.furniture ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          setState(() {
                            if (widget.isSelected.selected < limit) {
                              widget.isSelected.selected++;
                              barterto.add("Furniture & Accessories");
                              setState(() {
                                widget.isSelected.furniture = true;
                              });
                            } else {
                              showMaximum();
                            }
                          });
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Furniture & Accessories",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Furniture & Accessories");
                            setState(() {
                              widget.isSelected.furniture = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.bookStation ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Books & Stationery");
                            setState(() {
                              widget.isSelected.bookStation = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Books & Stationery",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Books & Stationery");
                            setState(() {
                              widget.isSelected.bookStation = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.homeAppliance ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Home Appliances");
                            setState(() {
                              widget.isSelected.homeAppliance = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Home Appliances",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Home Appliances");
                            setState(() {
                              widget.isSelected.homeAppliance = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.fashionCosmetic ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Fashion & Cosmetics");
                            setState(() {
                              widget.isSelected.fashionCosmetic = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Fashion & Cosmetics",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Fashion & Cosmetics");
                            setState(() {
                              widget.isSelected.fashionCosmetic = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.gameConsole ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Video Game & Consoles");
                            setState(() {
                              widget.isSelected.gameConsole = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Video Game & Consoles",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Video Game & Consoles");
                            setState(() {
                              widget.isSelected.gameConsole = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.forChildren ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("For Children");
                            setState(() {
                              widget.isSelected.forChildren = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("For Children",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("For Children");
                            setState(() {
                              widget.isSelected.forChildren = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.musicalInstrument ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Musical Instruments");
                            setState(() {
                              widget.isSelected.musicalInstrument = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Musical Instruments",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Musical Instruments");
                            setState(() {
                              widget.isSelected.musicalInstrument = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.sport ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Sports");
                            setState(() {
                              widget.isSelected.sport = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Sports",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Sports");
                            setState(() {
                              widget.isSelected.sport = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.foodNutrition ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Food & Nutrition");
                            setState(() {
                              widget.isSelected.foodNutrition = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Food & Nutrition",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Food & Nutrition");
                            setState(() {
                              widget.isSelected.foodNutrition = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSelected.other ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? Colors.grey[800]
                                : const Color.fromARGB(255, 246, 232, 222)),
                        onPressed: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Other");
                            setState(() {
                              widget.isSelected.other = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Other",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          if (widget.isSelected.selected < limit) {
                            widget.isSelected.selected++;
                            barterto.add("Other");
                            setState(() {
                              widget.isSelected.other = true;
                            });
                          } else {
                            showMaximum();
                          }
                        },
                        child: const Icon(Icons.add_circle_outline)),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      )),
    ));
  }

  void showMaximum() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Only Maximum of 5 item categories allowed")));
    return;
  }
}
