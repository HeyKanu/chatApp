import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/models/chatUser.dart';
import 'package:chet_app/screens/auth/loginscreen.dart';
import 'package:chet_app/screens/home.dart';
import 'package:chet_app/widgets/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class proFile extends StatefulWidget {
  final ChatUser Puser;
  proFile({super.key, required this.Puser});

  @override
  State<proFile> createState() => _proFileState();
}

String pic = "";

class _proFileState extends State<proFile> {
  var _formkey = GlobalKey<FormState>();
  


  void _showBottomsheet(context) {
    Get.bottomSheet(
      Container(
        height: 230,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Pick Profile Picture",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    print("camera");
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      log(image.path);
                      setState(() {
                        pic = image.path;
                      });
                      Apis.update_profile_pic(File(image.path!));

                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    "assets/icons/camera.png",
                    height: 100,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    print("Album");
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      log(image.path);
                      setState(() {
                        pic = image.path;
                      });
                      Apis.update_profile_pic(File(image.path!));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    "assets/icons/image-editing.png",
                    height: 100,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 2, 1, 46),
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("profile screen"),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                  ),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: pic == ""
                            ? CachedNetworkImage(
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                                imageUrl: widget.Puser.img,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.person),
                              )
                            : CircleAvatar(
                                radius: 70,
                                backgroundImage: FileImage(File(pic)),
                              ),
                        // child: Icon(CupertinoIcons.person),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -25,
                        child: MaterialButton(
                          color: Colors.amber,
                          shape: CircleBorder(),
                          onPressed: () {
                            _showBottomsheet(context);
                          },
                          child: Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 5,
                  ),
                  Text(
                    widget.Puser.email,
                    style: TextStyle(color: Colors.black45),
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 35,
                  ),
                  TextFormField(
                    initialValue: widget.Puser.name,
                    onSaved: (newValue) => Apis.me.name = newValue ?? "",
                    validator: (value) =>
                        value != null && value.isNotEmpty ? null : "enter name",
                    decoration: InputDecoration(
                      label: Text("Name"),
                      prefixIcon: Icon(
                        Icons.person,
                        color:  Color.fromARGB(255, 9, 78, 82),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 75, 75))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 75, 75))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 0, 0, 0))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: widget.Puser.about,
                    onSaved: (newValue) => Apis.me.about = newValue ?? "",
                    validator: (value) => value!.isNotEmpty && value != null
                        ? null
                        : " fill about section",
                    decoration: InputDecoration(
                      label: Text("About"),
                      prefixIcon: Icon(
                        Icons.info,
                        color: Color.fromARGB(255, 9, 78, 82),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 75, 75))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 75, 75))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 0, 0, 0))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 50,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:  Color.fromARGB(255, 9, 78, 82),
                      minimumSize: Size(100, 45),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        log("done");
                        _formkey.currentState!.save();
                        
                        Apis.update_me().then(
                          (value) =>
                              Get.snackbar("Successfully", "profile updated"),
                        );

                        Navigator.pop(context);
                      }
                    },
                    label: Text("Update"),
                    icon: Icon(Icons.edit),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 6, 30, 54),
          onPressed: () async {
           await Apis.update_active_Status(false);
          await  FirebaseFirestore.instance.collection("Allusers").doc(Apis.user.uid).update({"pushToken":" "});
            await Apis.firebase_auth.signOut();
            await GoogleSignIn().signOut().then((value) {
              
            // Navigator.pop(context);
            // Navigator.pop(context);
            Get.offAll(()=>login());
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => login(),
            //     ));

            },);

            

          },
          label: Text("Log out",style: TextStyle(color:  Colors.white),),
          icon: Icon(Icons.logout,color: Colors.white,),
        ),
      ),
    );
  }
}
