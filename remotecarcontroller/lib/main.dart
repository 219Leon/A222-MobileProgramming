import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Car',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    String answer = "";


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Car'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 350,
              width: 450,
              color: Color.fromARGB(255, 249, 255, 162),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox (
                      height:50,
                      width:100,
                      child: ElevatedButton(onPressed: () {onPressed('Forward');
                      }, child: const Text('Forward')),
                     ),
                    SizedBox (
                      height:25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      SizedBox (
                      height:50,
                      width:100,
                      child: ElevatedButton(onPressed: () {onPressed('Left');
                      }, child: const Text('Left')),
                      ),
                      SizedBox (
                      height:50,
                      width:100,
                      child: ElevatedButton(onPressed: () {onPressed('Stop');
                      }, child: const Text('Stop')),
                     ),
                     
                      SizedBox (
                      height:50,
                      width:100,
                      child: ElevatedButton(onPressed: () {onPressed('Right');
                      }, child: const Text('Right')),
                     ),
                  ],
                ),
                    SizedBox (
                      height:25),
                    SizedBox (
                      height:50,
                      width:100,
                      child: ElevatedButton(onPressed: () {onPressed('Reverse');
                      }, child: const Text('Reverse')),
                     ),
                    
          ]),
            )
        ),
                    const SizedBox (height:20),
                      Text(
                          answer, 
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),
                      )
        ],
        ),
      ),
    );
  }
  
  void onPressed(String s) {
    answer = s;
    setState(() {

    });
  }
}
