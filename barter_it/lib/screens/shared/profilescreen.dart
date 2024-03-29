import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:barter_it/screens/shared/registrationscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/user.dart';
import 'package:barter_it/config.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginscreen.dart';
import 'mainmenu.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final User user;
  final int selectedIndex;
  const ProfileScreen(
      {super.key, required this.user, required this.selectedIndex});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth, resWidth;
  File? _image;
  var pathAsset = "/assets/images/profile.jpg";
  final df = DateFormat('dd/MM/yyyy');
  var val = 50;

  bool isDisable = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  Random random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.user.id == "0") {
      isDisable = true;
    } else {
      isDisable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("User Profile")),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenHeight * 0.25,
                child: Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: SizedBox(
                        height: screenHeight * 0.25,
                        child: GestureDetector(
                          onTap: isDisable ? null : _updateImageDialog,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${Config.SERVER}/assets/profileimages/${widget.user.id}.jpg?v=$val",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.image_not_supported,
                                  size: 128),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.user.name.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                              child: Divider(
                                color: Colors.blueGrey,
                                height: 2,
                                thickness: 2.0,
                              ),
                            ),
                            Table(
                              columnWidths: const {
                                0: FractionColumnWidth(0.2),
                                1: FractionColumnWidth(0.8)
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(children: [
                                  const Icon(Icons.email),
                                  Text(
                                    widget.user.email.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ]),
                                TableRow(children: [
                                  const Icon(Icons.phone),
                                  Text(
                                    widget.user.phone.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ]),
                                widget.user.regdate.toString() == ""
                                    ? TableRow(children: [
                                        const Icon(Icons.date_range),
                                        Text(df.format(DateTime.parse(
                                            widget.user.regdate.toString())))
                                      ])
                                    : TableRow(children: [
                                        const Icon(Icons.date_range),
                                        Text(df.format(DateTime.now()))
                                      ]),
                                
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              )),
          Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth,
                      alignment: Alignment.center,
                      color: Theme.of(context).backgroundColor,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Text("PROFILE SETTINGS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                        child: ListView(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            shrinkWrap: true,
                            children: [
                          MaterialButton(
                            onPressed: isDisable ? null : _updateUsernameDialog,
                            child: const Text("UPDATE USERNAME"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _changePassDialog,
                            child: const Text("UPDATE PASSWORD"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _updatePhoneDialog,
                            child: const Text("UPDATE PHONE"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _updateAddressDialog,
                            child: const Text("UPDATE ADDRESS"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          MaterialButton(
                            onPressed: isDisable ? _registerAccountDialog : null,
                            child: const Text("NEW REGISTRATION"),
                          ),
                          MaterialButton(
                            onPressed: isDisable ? _loginDialog : null,
                            child: const Text("LOGIN"),
                          ),
                          MaterialButton(
                            onPressed: isDisable ? null : _logoutDialog,
                            child: const Text("LOGOUT"),
                          ),
                        ])),
                  ],
                ),
              )),
        ]),
        drawer: MainMenuWidget(user: widget.user),
      ),
    );
  }

  _updateUsernameDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: const Text("Change Username?", style: TextStyle()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }
                      return null;
                    }),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    String newUsername = _nameController.text;
                    _updateUsername(newUsername);
                  }),
              TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _updateUsername(String newUsername) {
    http.post(Uri.parse("${Config.SERVER}/php/update_profile.php"), body: {
      "userid": widget.user.id,
      "newname": newUsername,
    }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.name = newUsername;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  _updatePhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Phone?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new your phone';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newphone = _phoneController.text;
                _updatePhone(newphone);
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
      },
    );
  }

  void _updatePhone(String newphone) {
    http.post(Uri.parse("${Config.SERVER}/php/update_profile.php"), body: {
      "userid": widget.user.id,
      "newphone": newphone,
    }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.phone = newphone;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Password?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _newpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
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
      },
    );
  }

  void changePass() {
    http.post(Uri.parse("${Config.SERVER}/php/update_profile.php"), body: {
      "userid": widget.user.id,
      "oldpass": _oldpasswordController.text,
      "newpass": _newpasswordController.text,
    }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _updateAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Address?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                minLines: 6,
                maxLines: 6,
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: 'Home Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your home address';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newAddress = _addressController.text;
                updateAddress(newAddress);
              },
            ),
          ],
        );
      },
    );
  }

  void updateAddress(String newaddress) {
    http.post(Uri.parse("${Config.SERVER}/php/update_profile.php"), body: {
      "userid": widget.user.id,
      "newaddress": newaddress,
    }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.user.address = newaddress;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  _updateImageDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Select picture from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () =>
                      {Navigator.of(context).pop(), _galleryPicker()},
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery"),
                ),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ),
          );
        });
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateProfileImage(_image);
    }
  }

  void _updateProfileImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());
    http.post(Uri.parse("${Config.SERVER}/php/update_profile.php"), body: {
      "userid": widget.user.id,
      "image": base64Image,
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        val = random.nextInt(1000);
        setState(() {});
        //DefaultCacheManager manager = DefaultCacheManager();
        //manager.emptyCache(); //clears all data in cache.

      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout",
            style: TextStyle(),
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                await prefs.setBool('remember', false);
                User user = User(
                  id: "0",
                  email: "unregistered@email.com",
                  name: "unregistered",
                  address: "na",
                  phone: "0123456789",
                  regdate: "0",
                  credit: "0",
                );
                // ignore:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const LoginScreen()));
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
      },
    );
  }

  _registerAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register New Account",
            style: TextStyle(),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const RegistrationScreen()));
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
      },
    );
  }

  _loginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Login",
            style: TextStyle(),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const LoginScreen()));
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
      },
    );
  }
}
