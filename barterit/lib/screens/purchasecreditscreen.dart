import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class PurchaseType {
  String credit = "";
  String cost = "";

  PurchaseType({required this.credit, required this.cost});
}

class PurchaseCreditScreen extends StatefulWidget {
  final User user;
  const PurchaseCreditScreen({super.key, required this.user});

  @override
  State<PurchaseCreditScreen> createState() => _PurchaseCreditScreenState();
}

class _PurchaseCreditScreenState extends State<PurchaseCreditScreen> {
  late double screenWidth, screenHeight;
  String selected = "";
  int axiscount = 3;
  List<PurchaseType> purchaseList = [
    PurchaseType(credit: "5", cost: "RM 5.00"),
    PurchaseType(credit: "10", cost: "RM10.00"),
    PurchaseType(credit: "20", cost: "RM19.90"),
    PurchaseType(credit: "50", cost: "RM49.80"),
    PurchaseType(credit: "100", cost: "RM99.60"),
    PurchaseType(credit: "150", cost: "RM148.8"),
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (screenWidth > 600) {
      axiscount = 4;
    } else {
      axiscount = 3;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Top Up Credits",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Expanded(
                  child: GridView.count(
                      childAspectRatio: 4 / 5,
                      crossAxisCount: axiscount,
                      children: List.generate(
                        purchaseList.length,
                        (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: selected == purchaseList[index].cost
                                        ? Colors.tealAccent
                                        : Colors.grey,
                                    width: selected == purchaseList[index].cost
                                        ? 2
                                        : 1)),
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {
                                selected = purchaseList[index].cost;
                                setState(() {});
                              },
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        child: Image.asset(
                                            "assets/images/top-up.png")),
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
                                              "${purchaseList[index].credit} cred",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: selected ==
                                                        purchaseList[index].cost
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
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
                                          "RM ${purchaseList[index].cost}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          );
                        },
                      ))),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal),
                child: const Text(
                  "Purchase Credits",
                  style: TextStyle(
                      color:  Colors.white,
                      fontSize: 24),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              )
            ],
          ),
        ));
  }
}
