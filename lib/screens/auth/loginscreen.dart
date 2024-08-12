import 'dart:developer';
import 'dart:io';

import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/main.dart';
import 'package:chet_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  bool animat_icon = false;
  bool animat_button = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        animat_icon = true;
      });
    });
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        animat_button = true;
      });
    });
  }

  loder(BuildContext context) {
    showDialog(
      // barrierDismissible: bool.hasEnvironment("ll"),
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  _googleButton() {
    loder(context);
    _google_sign_in_fun().then((user) async {
      if (user != null) {
        print("USER:- ${user.user}");
        print("USER additional info :- ${user.additionalUserInfo}");
        if (await Apis.user_Exists()) {
          Get.snackbar(
            "Success",
            "Successfully Loginssssss  ",
          );
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => home(),
          //     ));
          Get.offAll(home());
        } else {
          await Apis.creatuser().then(
            (value) {
              Get.snackbar(
                "Success",
                "Successfully Login  ",
              );
          Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => home(),
                  ));
            },
          );
        }
      }
    });
    // Navigator.pop(context);
  }

  Future<UserCredential?> _google_sign_in_fun() async {
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? google_user = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication google_auth =
          await google_user!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: google_auth.accessToken, idToken: google_auth.idToken);
      return await Apis.firebase_auth.signInWithCredential(credential);
    } catch (e) {
      log("_google_sign_in_fun :- $e");

      Get.snackbar("Error", "check the internet",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 125, 9, 1));
      setState(() {});
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print(screenSize);
    return Scaffold(
      appBar: AppBar(
        title: Text("Wellcome to Chatfy"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            top: screenSize.height * .15,
            left: animat_icon ? screenSize.width * .22 : screenSize.width,
            height: screenSize.height * .3,
            child: Image.asset("assets/chat.png"),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: screenSize.height * .11,
            left: animat_button ? screenSize.width * .05 : screenSize.width,
            height: screenSize.height * .07,
            width: screenSize.width * .9,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 6, 30, 54)),
              onPressed: () {
                _googleButton();
              },
              icon: Image.asset(
                "assets/icons/gogle.png",
                height: 30,
              ),
              label: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                    TextSpan(text: "Sign in with "),
                    TextSpan(
                        text: "Google",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ])),
            ),
          )
        ],
      ),
    );
  }
}
