import 'package:flutter/material.dart';

class countryData extends StatelessWidget {
  String name, countryflag, capital, currency;
  countryData(
    {Key? key,
      required this.name,
      required this.countryflag,
      required this.capital,
      required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Image.network(countryflag, scale: 1),
              Text('Country Name: $name',),
              Text('Capital: $capital'),
              Text('Currency: $currency'),
            ],
          ),
      )),
    );
  }

}