import 'package:flutter/material.dart';
import '../model/user.dart';


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
    PurchaseType(credit: "5", cost: "5.00"),
    PurchaseType(credit: "10", cost: "10.00"),
    PurchaseType(credit: "20", cost: "20.00"),
    PurchaseType(credit: "50", cost: "50.00"),
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
          iconTheme: const IconThemeData(color:Colors.white),
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
                                        ? Colors.orange
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
                                    const SizedBox(height: 50),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              "${purchaseList[index].credit} credits",
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

                child: const Text(
                  "Purchase",
                  style: TextStyle(
                
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