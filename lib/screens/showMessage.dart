import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/halper/date_converter.dart';
import 'package:chet_app/main.dart';
import 'package:chet_app/models/messages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isme = Apis.user.uid == widget.message.formId;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
          onLongPress: () {
            log("edit buttom sheet");
            _show_buttomSheet(isme);
          },
          child: isme ? _greenMessage() : _blueMessage()),
    );
  }

  // sander
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      Apis.update_read_message(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 5, right: 50),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 218, 224, 246),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    border: Border.all(color: Colors.blue)),
                padding: widget.message.type == "text"
                    ? EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 70)
                    : EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: widget.message.type == "text"
                    ? Text(
                        widget.message.msg,
                        textAlign: TextAlign.start,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            height: 200,
                            width: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                          ),
                          imageUrl: widget.message.msg,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.photo),
                        )),
              ),
              Positioned(
                  bottom: widget.message.type == "text" ? 6 : 8,
                  right: widget.message.type == "text" ? 15 : 20,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Text(
                      date_converter.dateconvert(
                          context: context, time: widget.message.sent),
                      style: TextStyle(
                          fontSize: 10, color: Color.fromARGB(115, 0, 0, 0)),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  // owner
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //  Text(widget.message.sent,style: TextStyle(fontSize: 12,color: Colors.black45),),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 5, bottom: 0, left: 50),
                  decoration: BoxDecoration(
                      color:   Color.fromARGB(255, 6, 30, 54),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      border: Border.all(color: Color.fromARGB(255, 158, 250, 255))),
                  padding: EdgeInsets.all(10),
                  child: widget.message.type == "text"
                      ? Text(
                          widget.message.msg,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Container(
                                        height: 200,
                                        width: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                      ),
                              imageUrl: widget.message.msg,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.photo)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      //  margin: EdgeInsets.all(10),
                      child: Text(
                    date_converter.dateconvert(
                        context: context, time: widget.message.sent),
                    style: TextStyle(
                        fontSize: 10, color: Color.fromARGB(115, 0, 0, 0)),
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  if (widget.message.read.isNotEmpty)
                    Icon(
                      Icons.done_all,
                      size: 15,
                      color: Colors.blue,
                    )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void _show_buttomSheet(bool me) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40)),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 150),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
          widget.message.type == "text"
              ? _option(
                  icon: Icon(
                    Icons.copy,
                    color: Colors.blue,
                  ),
                  name: "Copy message",
                  ontap: () async {
                    await Clipboard.setData(
                            ClipboardData(text: widget.message.msg))
                        .then(
                      (value) {
                        Navigator.pop(context);
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message Copied")));
                        Get.snackbar("Copied", "Message Copied");
                      },
                    );
                  })
              : _option(
                  icon: Icon(
                    Icons.save_alt,
                    color: Colors.blue,
                  ),
                  name: "Save Image",
                  ontap: () async {
                    try {
                      String path = widget.message.msg;
                      log("Image path :- $path");
                      await GallerySaver.saveImage(
                        path,
                        albumName: "chatfy",
                      ).then((success) {
                        log('Image is saved');
                        Navigator.pop(context);
                        Get.snackbar("Saved", "Saved on your phone");
                      });
                    } catch (e) {
                      log("Image note save :- $e");
                    }
                  }),
          Divider(
            endIndent: 20,
            indent: 20,
          ),
          if (widget.message.type == "text" && me)
            _option(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                name: "Edit message",
                ontap: () {
                  Navigator.pop(context);
                  _editDailog();
                }),
          if (me)
            _option(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                name: "Delete message",
                ontap: () {
                  Apis.delete_msg(msg: widget.message);
                  Navigator.pop(context);
                  Get.snackbar("Delete", "Message deleted");
                }),
          if (me)
            Divider(
              endIndent: 20,
              indent: 20,
            ),
          _option(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.blue,
              ),
              name:
                  "Send At  ${date_converter.getLastMsgTime(context: context, time: widget.message.sent)} ",
              ontap: () {}),
          _option(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.green,
              ),
              name: widget.message.read.isEmpty
                  ? "Read At : Not seen yet"
                  : "Read At ${date_converter.getLastMsgTime(
                      context: context,
                      time: widget.message.read,
                    )} ",
              ontap: () {}),
        ],
      ),
    ));
  }

  void _editDailog() {
    String Updated_message = widget.message.msg;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          // mainAxisAlignment: d,
          children: [
            Icon(
              Icons.message,
              color: Colors.blue,
            ),
            Text("  Edit Message"),
          ],
        ),
        contentPadding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 20,
          top: 20,
        ),actionsPadding: EdgeInsets.only(bottom: 10,right: 10),
        content: TextFormField(
          initialValue: Updated_message,
          maxLength: null,
          onChanged: (value) {
            Updated_message=value;
          },
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  )),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ))),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (Updated_message.trim().isNotEmpty&&Updated_message.trim()!="") {
                
              Apis.update_msg(msg: widget.message, update_messame: Updated_message.trim());
              Navigator.pop(context);
              }
            },
            child: Text(
              "Update",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

class _option extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback ontap;
  const _option(
      {super.key, required this.icon, required this.name, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ontap,
        child: Container(
          padding: const EdgeInsets.only(left: 20, bottom: 15, top: 20),
          child: Row(
            children: [
              icon,
              Text(
                "  $name",
                style: TextStyle(
                    color: const Color.fromARGB(221, 35, 35, 35),
                    letterSpacing: 2),
              ),
            ],
          ),
        ));
  }
}
