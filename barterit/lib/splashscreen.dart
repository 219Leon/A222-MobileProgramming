import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'myconfig.dart';
import 'package:barterit/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/logo.png', scale: 4),
          Container(
            padding: EdgeInsets.fromLTRB(0, screenHeight * 0.75, 0, 0),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(style: TextStyle(color: Colors.grey), "from"),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Image.asset('assets/images/uum-logo.png', scale: 10),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/login_user.php"),
            body: {"email": email, "user_password": password}).then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            user = User.fromJson(jsondata['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                phone: "na",
                datereg: "na",
                password: "na",
                otp: "na",
                hasavatar: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          datereg: "na",
          password: "na",
          otp: "na",
          hasavatar: "na");
      Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
