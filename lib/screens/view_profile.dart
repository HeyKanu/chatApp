import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/halper/date_converter.dart';
import 'package:chet_app/models/chatUser.dart';
import 'package:chet_app/screens/auth/loginscreen.dart';
import 'package:chet_app/screens/home.dart';
import 'package:chet_app/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class View_proFile extends StatefulWidget {
  final ChatUser Puser;
  View_proFile({super.key, required this.Puser});

  @override
  State<View_proFile> createState() => _View_proFileState();
}



class _View_proFileState extends State<View_proFile> {
  var _formkey = GlobalKey<FormState>();

 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.Puser.name),
        ),
      floatingActionButton:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                        "Joined On: ",
                        style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
                                         ),
                       Text(
                        date_converter.joinAt(context: context, time: widget.Puser.createdAt,showYear: true),
                        style: TextStyle(color: Colors.black45,fontSize: 14),
                                         ),
                     ],
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
                        child:  CachedNetworkImage(
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
                         
                        // child: Icon(CupertinoIcons.person),
                      ),
                     
                    ],
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 5,
                  ),
                  Text(
                    widget.Puser.email,
                    style: TextStyle(color: Colors.black,fontSize: 15),
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 5,
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                        "About: ",
                        style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
                                         ),
                       Text(
                        widget.Puser.about,
                        style: TextStyle(color: Colors.black45,fontSize: 14),
                                         ),
                     ],
                   ),
                  SizedBox(
                    // width: double.infinity,
                    height: 50,
                  ),
                   ],
              ),
            ),
          ),
        ),
     
      ),
    );
  }
}
