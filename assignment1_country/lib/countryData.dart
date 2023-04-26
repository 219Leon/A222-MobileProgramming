import 'package:flutter/material.dart';

class countryData extends StatelessWidget {
  List name, isoCodeList, capitalList, currencyNameList, currencyCodeList;
  
  countryData(
    {Key? key,
      required this.name,
      required this.isoCodeList,
      required this.capitalList,
      required this.currencyNameList,
      required this.currencyCodeList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String finalName = name.reduce((value, element) {
      return value + element;
    });
    String isoCode = isoCodeList.reduce((value, element) {
      return value + element;
    });
    String capital = capitalList.reduce((value, element) {
      return value + element;
    });
    String currencyName = currencyNameList.reduce((value, element) {
      return value + element;
    });
        String currencyCode = currencyCodeList.reduce((value, element) {
      return value + element;
    });
    String flagUrl = 'https://flagsapi.com/$isoCode/flat/64.png';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Country Information'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(flagUrl),
              Text('Country Name: $finalName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Capital: $capital', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Currency Name: $currencyName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Currency Code: $currencyCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
      )),
    );
  }

}