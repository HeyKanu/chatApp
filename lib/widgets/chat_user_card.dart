import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/halper/date_converter.dart';
import 'package:chet_app/models/chatUser.dart';
import 'package:chet_app/models/messages.dart';
import 'package:chet_app/screens/chateScreeen.dart';
import 'package:chet_app/widgets/profile_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class chat_card extends StatefulWidget {
  final ChatUser user;
  final bool buttomSheet;
  const chat_card({super.key, required this.user, required this.buttomSheet});
  @override
  State<chat_card> createState() => _chat_cardState();
}

class _chat_cardState extends State<chat_card> {
  Message ?_msg;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: InkWell(
          onTap: () {
            if (widget.buttomSheet) {
              
            Navigator.pop(context);
            }
            Get.to(() => Chatescreeen(user: widget.user,));
          },
          child:StreamBuilder(stream: Apis.getLastMessage(widget.user), builder: (context, snapshot) {
            final data = snapshot.data?.docs;
                  print("Data :- $data");
               final list = data
                          ?.map((e) => Message.fromJson( e.data()))
                          .toList() ??
                      [];
              if (list.isNotEmpty) {
                _msg=list[0];
              }

            return  ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(55),
                child: GestureDetector(
                  onTap: (){
                    log("message");
                    showDialog(context: context, builder: (context) {
                      log(widget.user.img);
                      return profile_Dialog(user: widget.user,) ;
                    },);
                  },
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: widget.user.img,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                            value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                // child: Icon(CupertinoIcons.person),
              ),
              title: Text(widget.user.name),
              subtitle: Text(_msg !=null? _msg!.type=="text"? _msg!.msg:"Image 🌄": widget.user.about, maxLines: 1,overflow: TextOverflow.ellipsis,),
              trailing:_msg==null?null:_msg!.read.isEmpty&&_msg!.formId != Apis.user.uid? Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
              ): Text(date_converter.getLastMsgTime(context: context, time:  _msg!.sent)
               ,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              )
              // trailing: Text(
              //   "12:00 pm",
              //   style: TextStyle(fontSize: 12, color: Colors.black54),
              // ),
              ) ;
          },)
        ),
      ),
    );
  }
}
