import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/halper/date_converter.dart';
import 'package:chet_app/main.dart';
import 'package:chet_app/models/chatUser.dart';
import 'package:chet_app/models/messages.dart';
import 'package:chet_app/screens/showMessage.dart';
import 'package:chet_app/screens/view_profile.dart';
import 'package:chet_app/state/emojiProvider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Chatescreeen extends StatefulWidget {
  final ChatUser user;
  const Chatescreeen({super.key, required this.user});

  @override
  State<Chatescreeen> createState() => _ChatescreeenState();
}

class _ChatescreeenState extends State<Chatescreeen> {
  List<Message> _list = [];
//  bool _emoji=false;
  var msg_controller = TextEditingController();
  @override
  Future sendNotification_Text(
      {required List<String> tokenIdList,
      required String contents,
      required String heading}) async {
    log("TTTTTTT== $tokenIdList");
    return await post(Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "app_id":
              "13158697-b399-4ee2-b00d-135224169bdd", //kAppId is the App Id that one get from the OneSignal When the application is registered.

          "include_player_ids":
              tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

          // android_accent_color reprsent the color of the heading text in the notifiction
          "android_accent_color": "FF9976D2",

          // "small_icon":"ic_stat_onesignal_default",

          // "large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

          "headings": {"en": heading},

          "contents": {"en": contents},
        }));
  }

  Future sendNotification_Image(
      {required List<String> tokenIdList,
      required String ImgUrl,
      required String heading,
      required String contents}) async {
    log("TTTTTTT== $tokenIdList");
    return await post(Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "app_id":
              "13158697-b399-4ee2-b00d-135224169bdd", //kAppId is the App Id that one get from the OneSignal When the application is registered.

          "include_player_ids":
              tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

          // android_accent_color reprsent the color of the heading text in the notifiction
          "android_accent_color": "FF9976D2",

          // "small_icon":"ic_stat_onesignal_default",

          'big_picture': ImgUrl,
          "large_icon": ImgUrl,

          "headings": {"en": heading},

          "contents": {"en": contents},
        }));
  }

  Widget build(BuildContext context) {
    var MyEmoji = Provider.of<Show_emoji>(context, listen: false);
    final FocusNode _textFieldFocusNode = FocusNode();

    Widget input_chet() {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MyEmoji.SHOW_EMOJI ? 0 : 30, right: 10, left: 10),
        child: Row(
          children: [
            Expanded(
              child: Card(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _textFieldFocusNode.unfocus();
                        MyEmoji.update_emoji(
                            MyEmoji.SHOW_EMOJI == true ? false : true);
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color:  const Color.fromARGB(255, 255, 196, 68),
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: Offset(0, 0))
                        ],
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                      focusNode: _textFieldFocusNode,
                      onTap: () {
                        if (MyEmoji.SHOW_EMOJI) {
                          MyEmoji.update_emoji(false);
                        }
                      },
                      controller: msg_controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type Somthing...",
                      ),
                      maxLines: null,
                    )),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        MyEmoji.UPLOAD_LOADER(true);
                        for (var i in images) {
                          String imgUrl =
                              await Apis.send_Img(widget.user, File(i!.path));
                          await sendNotification_Image(
                              tokenIdList: [widget.user.pushToken],
                              contents: "Send Image 🌄",
                              heading: Apis.user.displayName.toString(),
                              ImgUrl: imgUrl);
                        }
                        MyEmoji.UPLOAD_LOADER(false);
                      },
                      icon: Icon(
                        Icons.photo,
                        color: Color.fromARGB(255, 9, 78, 82),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        MyEmoji.UPLOAD_LOADER(true);
                        if (image != null) {
                          String imgUrl = await Apis.send_Img(
                              widget.user, File(image!.path));
                          sendNotification_Image(
                              tokenIdList: [widget.user.pushToken],
                              contents: "Send Image 🌄",
                              heading: Apis.user.displayName.toString(),
                              ImgUrl: imgUrl);
                        }
                        MyEmoji.UPLOAD_LOADER(false);
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Color.fromARGB(255, 9, 78, 82),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (msg_controller.text.trim().isNotEmpty) {
                    if (_list.isEmpty) {
                      Apis.addUserChatList(widget.user);
                    }
                    Apis.sendMassage(widget.user, msg_controller.text, "text");

                    // ====================================(push notifction)
                    log("push id ---- ${widget.user.pushToken}");
                    sendNotification_Text(
                        tokenIdList: [widget.user.pushToken],
                        contents: msg_controller.text,
                        heading: Apis.user.displayName.toString());
                    msg_controller.clear();
                  }
                },
                icon: Icon(Icons.send,color:  Color.fromARGB(255, 9, 78, 82),))
          ],
        ),
      );
    }

    log("message___________________________");
    return WillPopScope(
      onWillPop: () {
        if (MyEmoji.SHOW_EMOJI) {
          MyEmoji.update_emoji(false);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          _textFieldFocusNode.unfocus();

          if (MyEmoji.SHOW_EMOJI) {
            MyEmoji.update_emoji(false);
            // return Future.value(false);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appbar(),
          ),
          // backgroundColor: Color.fromARGB(255, 218, 224, 246),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: Apis.getAllMessage(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        // log("Data :- ${jsonEncode(data![0].data())}");
                        // _list.clear();
                        print(data);
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: _list.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                                top: 2, left: 2, right: 2, bottom: 30),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: _list[index],
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: GestureDetector(
                                  onTap: () {
                                    if (_list.isEmpty) {
                                      Apis.addUserChatList(widget.user);
                                    }
                                    Apis.sendMassage(
                                        widget.user, "Hii", "text");

                                    // ====================================(push notifction)
                                    log("push id ---- ${widget.user.pushToken}");
                                    sendNotification_Text(
                                        tokenIdList: [widget.user.pushToken],
                                        contents: "Hii",
                                        heading:
                                            Apis.user.displayName.toString());
                                    msg_controller.clear();
                                  },
                                  child: Text(
                                    "Say Hii! 👋",
                                    style: TextStyle(fontSize: 30),
                                  )));
                        }
                        ;
                    }
                  },
                ),
              ),
              Consumer<Show_emoji>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      if (value.UPLOAD_IMAGE) CircularProgressIndicator(),
                      input_chet(),
                      value.SHOW_EMOJI
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: SizedBox(
                                height: 250,
                                width: double.infinity,
                                child: EmojiPicker(
                                  config: Config(
                                      bottomActionBarConfig:
                                          BottomActionBarConfig(
                                              enabled: true,
                                              showSearchViewButton: false,
                                              backgroundColor:
                                                  Colors.transparent,
                                              buttonIconColor: Colors.blue)),
                                  textEditingController: msg_controller,
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {
        Get.to(() => View_proFile(Puser: widget.user));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: StreamBuilder(
                stream: Apis.getUserInfo(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  print("Data :- $data");
                  final list = data
                          ?.map((e) => ChatUser.fromjson(json: e.data()))
                          .toList() ??
                      [];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      // SizedBox(width: 10,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl:
                              list.isNotEmpty ? list[0].img : widget.user.img,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        // child: Icon(CupertinoIcons.person),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list.isNotEmpty ? list[0].name : widget.user.name,
                            style: TextStyle(
                                color: Color.fromARGB(225, 255, 255, 255),
                                fontSize: 17),
                          ),
                          Text(
                              list.isNotEmpty
                                  ? list[0].isOnline
                                      ? "Online"
                                      : date_converter.getLastActiveTime(
                                          context: context,
                                          last_active_time: list[0].lastActiv)
                                  : date_converter.getLastActiveTime(
                                      context: context,
                                      last_active_time: widget.user.lastActiv),
                              style: TextStyle(
                                color: Color.fromARGB(146, 255, 255, 255),
                              )),
                        ],
                      )
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }
}
