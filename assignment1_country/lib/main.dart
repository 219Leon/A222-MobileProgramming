import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:assignment1_country/countryData.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Information',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}): super(key:key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _countryName = TextEditingController();
  var desc = "", searchCountry = "";
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
                      ElevatedButton(
                        onPressed: _getCountry,
                        child: const Text("Load Information")),
                      Text(desc, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red))  
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


  Future<void> _getCountry() async {   
    searchCountry = _countryName.text;
    String apiid = "7T46D8Hm7NRGepZtN0JaFA==yBG6aI3mJeLtBrJp";
    Uri url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$searchCountry');
    var responses = await http.get(url, headers: {"X-Api-Key": apiid});
    var rescode1 = responses.statusCode;
    if (rescode1 == 200){
      var jsonData = responses.body;
      List parsedJson = json.decode(jsonData);
      List countryName = [], countryCode = [], countryCapital = [], countryCurrencyCode = [], countryCurrencyName = []; 
      if (parsedJson.isNotEmpty) {
        setState(() {
          countryName.add(parsedJson[0]['name']);
          countryCode.add(parsedJson[0]['iso2']);
          countryCapital.add(parsedJson[0]['capital']);
          countryCurrencyCode.add(parsedJson[0]['currency']['code']);
          countryCurrencyName.add(parsedJson[0]['currency']['name']);
          print("Country Name: $countryName\nCapital: $countryCapital\nCurrency: $countryCurrencyName ($countryCurrencyCode)");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => countryData(
              name: countryName, 
              isoCodeList: countryCode, 
              capitalList: countryCapital, 
              currencyNameList: countryCurrencyName, 
              currencyCodeList: countryCurrencyCode)));
        });
      } else {
        print("Error: Country not found");
        desc = "Country not found!";
      }
    } else {
      print("Error: Unable to obtain information");
      desc = "Error obtaining information.";
    }
  }
}

