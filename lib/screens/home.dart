import 'dart:developer';

import 'package:chet_app/api/Apis.dart';
import 'package:chet_app/main.dart';
import 'package:chet_app/models/chatUser.dart';
import 'package:chet_app/screens/auth/loginscreen.dart';

import 'package:chet_app/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import './profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class home extends StatefulWidget {
  home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<ChatUser> _list = [];
  List<ChatUser> _searchlist = [];
  bool _isSearch = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.getSelfInfo();
    Apis.updateToken();

    SystemChannels.lifecycle.setMessageHandler(
      (message) {
        log("message:- $message");
        if (Apis.firebase_auth.currentUser != null) {
          // Apis.update_active_Status(true);
          if (message.toString().contains("resume")) {
            Apis.update_active_Status(true);
          } // online
          if (message.toString().contains("pause")) {
            Apis.update_active_Status(false);
          } // offline
        }
        return Future.value(message);
      },
    );
  }

  Widget appAllUsers({required List<String> ids, required bool all}) {
    return StreamBuilder(
      stream: Apis.get_All_App_user(ids: ids, isAll: all),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            print("Data :- $data");
            _list =
                data?.map((e) => ChatUser.fromjson(json: e.data())).toList() ??
                    [];
            if (_list.isNotEmpty) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _isSearch ? _searchlist.length : _list.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 30),
                itemBuilder: (context, index) {
                  return chat_card(
                    user: _isSearch ? _searchlist[index] : _list[index],
                    buttomSheet: true,
                  );
                },
              );
            } else {
              return Center(child: Text("NO connection found"));
            }
        }
      },
    );
  }

  final FocusNode _textFieldFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_textFieldFocusNode.hasFocus) {
          _textFieldFocusNode.unfocus();
            setState(() {
              _isSearch = !_isSearch;
            });
        }
        // FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (_isSearch) {
            setState(() {
              _isSearch = !_isSearch;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.home_filled),
            title: _isSearch
                ? Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      focusNode: _textFieldFocusNode,
                      onChanged: (val) {
                        setState(() {
                          _searchlist.clear();
                          log("list :- $_searchlist");
                        });
                        log("message :- $val");
                        for (var element in _list) {
                          if ((element.name
                                  .toLowerCase()
                                  .contains("${val.toLowerCase()}")) ||
                              (element.email
                                  .toLowerCase()
                                  .contains("${val.toLowerCase()}"))) {
                            setState(() {
                              _searchlist.add(element);
                              log("message____ $_searchlist");
                            });
                          }
                        }
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "Name, Email, .....",
                          hintStyle: TextStyle(color: Colors.white38),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: InputBorder.none),
                    ),
                  )
                : Text("Chatfy"),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearch = !_isSearch;
                    });
                    log("Search....");
                  },
                  child: Icon(_isSearch
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    onTap: () {
                      //   await Apis.auth.signOut();
                      //   await GoogleSignIn().signOut();
                      Get.to(() => proFile(
                            Puser: Apis.me,
                          ));
                    },
                    child: Icon(Icons.more_vert)),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: Apis.getAlluser_to_chat(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  print("Data :- $data");
                  _list = data?.map(
                        (e) {
                          return ChatUser.fromjson(json: e.data());
                        },
                      ).toList() ??
                      [];
                  if (_list.isNotEmpty) {
                    return StreamBuilder(
                      stream: Apis.get_All_App_user(
                          ids: snapshot.data?.docs
                                  .map(
                                    (e) => e.id,
                                  )
                                  .toList() ??
                              [],
                          isAll: false),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            print("Data :- $data");
                            _list = data?.map(
                                  (e) {
                                    return ChatUser.fromjson(json: e.data());
                                  },
                                ).toList() ??
                                [];
                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: _isSearch
                                    ? _searchlist.length
                                    : _list.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    top: 2, left: 2, right: 2, bottom: 30),
                                itemBuilder: (context, index) {
                                  return chat_card(
                                    user: _isSearch
                                        ? _searchlist[index]
                                        : _list[index],
                                    buttomSheet: false,
                                  );
                                },
                              );
                            } else {
                              return Center(child: Text("NO connection found"));
                            }
                            ;
                        }
                      },
                    );
                  } else {
                    return Center(child: Text("NO connection found"));
                  }
                  ;
              }
            },
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 6, 30, 54),
                // shape: Border.all(),

                splashColor: Colors.black,
                onPressed: () async {
                  Get.bottomSheet(
                      isScrollControlled: true,
                      SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            // height: double.infinity,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              children: [
                                appAllUsers(all: true, ids: []),
                              ],
                            )),
                      ));
                },
                child: Icon(
                  Icons.chat_sharp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
