import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:assignment1_country/countryData.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Information',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Country Information'),
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 2)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 40
    ..radius = 10
    ..progressColor = Colors.indigo
    ..backgroundColor = const Color.fromARGB(255, 255, 255, 187)
    ..textColor = Colors.black
    ..indicatorColor = Colors.indigo
    ..maskColor = Colors.indigo.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apiid = "7T46D8Hm7NRGepZtN0JaFA==yBG6aI3mJeLtBrJp";
  var desc = "No information available";
  final TextEditingController _countryName = TextEditingController();
  
    Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Country Information'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width:325,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Country Information",
                      style: TextStyle(
                        fontSize: 25, 
                        fontWeight: FontWeight.bold),
                        ),
                      const SizedBox (height:20),
                      TextField(
                        controller: _countryName,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: "Type country name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                      ),
                      const SizedBox (height:10),
                      ElevatedButton(onPressed: () {_getCountry();
                      }, 
                        child: const Text("Load Information")),
                        Text(desc, 
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _progressindicator() {
    showDialog(
      context: context,
      builder: (context) {
        const Duration(seconds: 3);
        EasyLoading.addStatusCallback((status) {
          print('EasyLoading Status $status');
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        EasyLoading.showSuccess('Search Success');
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _getCountry() async {
    
    var apiid = "7T46D8Hm7NRGepZtN0JaFA==yBG6aI3mJeLtBrJp";
    var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=');
    var responses = await http.get(url);
    var rescode = responses.statusCode;
    if (rescode == 200){
      var jsonData = responses.body;
      var parsedJson = json.decode(jsonData);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => countryData(
        name: _countryName.text, 
        countryflag: countryflag, 
        capital: capital, 
        currency: currency)));
    } else{
      print("Error: Failed to acquire country info");
    }
  }
}

