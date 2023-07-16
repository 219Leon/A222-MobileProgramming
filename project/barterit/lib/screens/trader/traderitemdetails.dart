import 'dart:async';
import 'dart:math';
import 'package:barterit/screens/user/selectuseritem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../model/items.dart';
import 'package:barterit/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TraderItemDetails extends StatefulWidget {
  final User user, trader;
  final Item item;
  const TraderItemDetails(
      {super.key,
      required this.user,
      required this.item,
      required this.trader});

  @override
  State<TraderItemDetails> createState() => _traderItemDetailsScreen();
}

class _traderItemDetailsScreen extends State<TraderItemDetails> {
  late double screenHeight, screenWidth, resWidth;
  late List<String> imageList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    imageList = [
      "${Config.SERVER}/assets/itemimages/${widget.item.itemId}_1.png",
      "${Config.SERVER}/assets/itemimages/${widget.item.itemId}_2.png",
      "${Config.SERVER}/assets/itemimages/${widget.item.itemId}_3.png"
    ];
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar:
          AppBar(title: Text("Details for ${widget.item.itemName.toString()}")),
      body: Column(children: [
        const SizedBox(height: 10),
        Text(widget.item.itemName.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              autoPlay: false,
            ),
            items: imageList.map((url) {
              return Builder(builder: (BuildContext context) {
                return CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (context, url) => LinearProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              });
            }).toList()),
        const SizedBox(height: 20),
        SizedBox(
          width: screenWidth - 16,
          child: Table(
            border: TableBorder.all(
                color: Colors.black, style: BorderStyle.none, width: 1),
            columnWidths: const {
              0: FixedColumnWidth(80),
              1: FixedColumnWidth(10),
              2: FixedColumnWidth(180),
            },
            children: [
              TableRow(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Item ID', style: TextStyle(fontSize: 13))
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      "I-${widget.item.userId.toString().padLeft(5, '0')}${widget.item.itemId.toString().padLeft(3, '0')}",
                      style: const TextStyle(fontSize: 13)),
                ]),
              ]),
              TableRow(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Description', style: TextStyle(fontSize: 13))
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.item.itemDesc.toString(),
                      style: const TextStyle(fontSize: 13)),
                ]),
              ]),
              TableRow(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Retail Price', style: TextStyle(fontSize: 13))
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      "RM ${double.parse(widget.item.itemPrice.toString()).toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 13)),
                ]),
              ]),
              TableRow(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Delivery Fees', style: TextStyle(fontSize: 13))
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      "RM ${double.parse(widget.item.itemDelivery.toString()).toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 13)),
                ]),
              ]),
              TableRow(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Quantity', style: TextStyle(fontSize: 13))
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.item.itemQty.toString(),
                      style: const TextStyle(fontSize: 13)),
                ]),
              ]),
              TableRow(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Locality', style: TextStyle(fontSize: 13))
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("${widget.item.itemLocal}",
                      style: const TextStyle(fontSize: 13)),
                ]),
              ]),
              TableRow(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('seller Name', style: TextStyle(fontSize: 13))
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("${widget.trader.name}",
                      style: const TextStyle(fontSize: 13))
                ]),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 40),
        
        ElevatedButton(
            onPressed: () {
              addtocartdialog();
            },
            child: const Text("Barter for this item")),
        Expanded(
            child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Card(
              child: SizedBox(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  iconSize: 35,
                  onPressed: _makePhoneCall,
                  icon: const Icon(Icons.call)),
              IconButton(
                  iconSize: 35,
                  onPressed: _whatsApp,
                  icon: const Icon(Icons.whatsapp)),
              IconButton(
                  iconSize: 35,
                  onPressed: _makeSmS,
                  icon: const Icon(Icons.message)),
              IconButton(
                  iconSize: 35,
                  onPressed: _onRoute,
                  icon: const Icon(Icons.map)),
              IconButton(
                  iconSize: 35,
                  onPressed: _onShowMap,
                  icon: const Icon(Icons.maps_home_work)),
            ],
          ))),
        )),
      ]),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.trader.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeSmS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.trader.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _onRoute() async {
    final Uri launchUri = Uri(
        scheme: 'https',
        path:
            "www.google.com/maps/@${widget.item.itemLat},${widget.item.itemLng}20z");
    await launchUrl(launchUri);
  }

  Future<void> _whatsApp() async {
    final Uri launchUri =
        Uri(scheme: 'https', path: "wa.me/6${widget.trader.phone}");
    await launchUrl(launchUri);
  }

  int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  void _onShowMap() {
    double lat = double.parse(widget.item.itemLat.toString());
    double lng = double.parse(widget.item.itemLng.toString());
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    int markerIdVal = generateIds();
    MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        lat,
        lng,
      ),
    );
    markers[markerId] = marker;

    CameraPosition campos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.4746,
    );
    Completer<GoogleMapController> ncontroller =
        Completer<GoogleMapController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Location",
            style: TextStyle(),
          ),
          content: Container(
            color: Colors.blueAccent,
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: campos,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                ncontroller.complete(controller);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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

  void addtocartdialog() {
    if (widget.user.id.toString() == "na") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please register to barter item")));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
             shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Add ${widget.item.itemName} to barter",
          ),
          content: const Text("Are your sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                selectUserItem();
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
  void selectUserItem(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
        SelectUserItem(user: widget.user, trader: widget.trader, traderItem: widget.item)
      ));
  }
}
