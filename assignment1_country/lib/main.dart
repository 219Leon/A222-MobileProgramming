import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Information',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Country Information'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apiid = "";
  var desc = "No information available";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    SizedBox (height:20),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Type country name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ),
                    SizedBox (height:10),
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
    );
  }


  Future<void> _getCountry() async {
    var apiid = "";
    var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=');
    //var responses = await http.get(url);
    //var rescode = response.statusCode;

  }
}
