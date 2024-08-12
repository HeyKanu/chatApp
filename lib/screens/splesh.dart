import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/screens/auth/loginscreen.dart';
import 'package:chet_app/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class splesh extends StatefulWidget {
  const splesh({super.key});

  @override
  State<splesh> createState() => _spleshState();
}

class _spleshState extends State<splesh> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemStatusBarContrastEnforced: false,
          systemNavigationBarColor: Color.fromARGB(0, 250, 250, 250), ), );
      if (Apis.firebase_auth.currentUser != null) {
        Get.off(home(),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 700));
      } else {
        Get.offAll(login(),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 700));
      }

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => home(),
      //     ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset(
            "assets/chat.png",
            height: 200,
          ),
        ));
  }
}
