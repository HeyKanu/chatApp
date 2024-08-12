import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:chet_app/models/chatUser.dart';
import 'package:chet_app/models/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' ;
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as service_control;

class Apis {
  static FirebaseAuth firebase_auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage store = FirebaseStorage.instance;
  static User get user => firebase_auth.currentUser!;
  static late ChatUser me;
  // static FirebaseMessaging Fmessaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessageToken() async{
   
    
String? tokenId =await  OneSignal.User.pushSubscription.id;
    log("one signal fun ID = $tokenId ");

// ===============================================================

     if (tokenId!=null) {
       me.pushToken=tokenId;
       firestore.collection('users').doc(user.uid).collection('my_user').doc(me.id).update({"pushToken":tokenId});
       firestore.collection("Allusers").doc(user.uid).update({"pushToken":tokenId});
       log("push token :- $tokenId");
     }
  }
  static Future<void> updateToken() async{
    String? tokenId =await  OneSignal.User.pushSubscription.id;
     firestore.collection("Allusers").doc(user.uid).update({"pushToken":tokenId});
  }
  static Future<bool> user_Exists() async {
    return (await firestore.collection("users").doc(user.uid).collection('my_user').doc(user.uid).get()).exists;
  }

  static Future getSelfInfo() async {
    firestore.collection("Allusers").doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          me = await ChatUser.fromjson(json: user.data()!);
         await getFirebaseMessageToken();
          await Apis.update_active_Status(true);
        } else {
          await creatuser().then(
            (value) => getSelfInfo(),
          );
        }
      },
    );
  }

  static Future<void> creatuser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatuser = ChatUser(
        name: user.displayName.toString(),
        about: "i'm so happy",
        createdAt: time,
        email: user.email.toString(),
        id: user.uid,
        img: user.photoURL.toString(),
        isOnline: false,
        lastActiv: time,
        pushToken: "");

    // await firestore.collection("users").doc(user.uid).set(chatuser.toJson());
    await firestore.collection("Allusers").doc(user.uid).set(chatuser.toJson());
  }
  static Future<void> addUserChatList(ChatUser _chatUser)async{
   await firestore.collection('users').doc(user.uid).collection('my_user').doc(_chatUser.id).set(_chatUser.toJson());
   await firestore.collection('users').doc(_chatUser.id).collection('my_user').doc(me.id).set(me.toJson());
  }
// static List<String> ids=[];
// static  getchatusersIds()async{
//        log("id ---- ${user.uid}");
//        ids.clear();
//          final querySnapshot = await FirebaseFirestore.instance
//         .collection('users').doc(user.uid).collection('my_user').get();
//         for (var element in querySnapshot.docs) {
//         log("doc id ------- ${element.id}");
//         ids.add(element.id);
//         }
        
//   }
  static  Stream<QuerySnapshot<Map<String, dynamic>>> getAlluser_to_chat() {
    return firestore.collection('users').doc(user.uid).collection('my_user')
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> get_All_App_user({required List<String> ids,required bool isAll}) {
   if (isAll) {
      return firestore
        .collection('Allusers')
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
     
   } else {
      return firestore
        .collection('Allusers')
        .where("id", whereIn: ids)
        .snapshots();
   }
  }
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAlluser() {
  //   return firestore
  //       .collection('users')
  //       .where("id", isNotEqualTo: user.uid)
  //       .snapshots();
  // }

  static Future<void> update_me() async {
         firestore.collection("Allusers").doc(user.uid).update({"name": me.name, "about": me.about});
        }

  static Future<void> update_profile_pic(File file) async {
    final ext = file.path.split(".").last;
    final ref = store.ref().child("profileImg/${user.uid}.$ext");
    await ref.putFile(file, SettableMetadata(contentType: "image/$ext")).then(
      (p0) {
        log("Size ${p0.bytesTransferred / 1000}.kb");
      },
    );
    me.img = await ref.getDownloadURL();
  //  firestore.collection('users').doc(user.uid).collection('my_user').doc(me.id).update({
  //     "img": me.img,
  //   });
    firestore.collection("Allusers").doc(user.uid).update({
      "img": me.img,
    });
  }
 //------------------------------------------------------------------ ( chat Screen APis ) ------------------------------
    static String getConvoID(String id)=>user.uid.hashCode <= id.hashCode?"${user.uid}_$id":"${id}_${user.uid}";
    // +++++++++++++++++++++++++++++++++++++  (get message )
    static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(ChatUser us) {
      log("message:- ${getConvoID(us.id)}");
      String abc=getConvoID(us.id);
    return  firestore
        .collection('chats/${abc}/messages/').orderBy("sent",descending: true)
        .snapshots();
  }
  // +++++++++++++++++++++++++++++++++++++  (send message)  
  static Future sendMassage(ChatUser chatuser,String msg, String Type)async{
    final time =DateTime.now().millisecondsSinceEpoch.toString();
    Message message =Message(formId: user.uid, msg: msg, read: "", told: chatuser.id, type: Type, sent: time);
    final ref =firestore.collection('chats/${getConvoID(chatuser.id)}/messages/');
   await ref.doc(time).set(message.toJson());
  }


  static Future update_read_message(Message mesg)async{
    firestore.collection('chats/${getConvoID(mesg.formId)}/messages/').doc(mesg.sent).update({"read":DateTime.now().millisecondsSinceEpoch.toString()});
  }

  
 static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser us) {
      
      String abc=getConvoID(us.id);
  return firestore.collection('chats/${abc}/messages/').orderBy("sent",descending: true).limit(1).snapshots();
  }


// ==================================   (sand image on firebase)
  static Future<String> send_Img(ChatUser chat_user,File file)async{
   final ext = file.path.split(".").last;
    final ref = store.ref().child("Images/${getConvoID(chat_user.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    await ref.putFile(file, SettableMetadata(contentType: "image/$ext")).then(
      (p0) {
        log("Size ${p0.bytesTransferred / 1000}.kb");
      },
    );
    final ImgUrl = await ref.getDownloadURL();
    await sendMassage(chat_user, ImgUrl,"image");
    return ImgUrl;
  }

  // ______________________________   (get specific user info)  _________________________

   static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatuser) {      
  return firestore.collection("Allusers").where("id" ,isEqualTo: chatuser.id).snapshots();
  }
  // ______________________________   (Update online or offline and last active status)  _________________________

  static Future<void> update_active_Status(bool isOnline)async{
    firestore.collection('Allusers').doc(user.uid).update({
      "isOnline":isOnline,
      "lastActiv":DateTime.now().millisecondsSinceEpoch.toString(),
      "pushToken":me.pushToken,
      });
  }
  static Future<void> delete_msg({required Message msg})async{
     await  firestore.
       collection('chats/${getConvoID(msg.told)}/messages/')
       .doc(msg.sent)
       .delete();
      if (msg.type!="image") {
      await store.refFromURL(msg.msg).delete();
      }
  }
  static Future<void> update_msg({required Message msg ,required String update_messame})async{
     await  firestore.
       collection('chats/${getConvoID(msg.told)}/messages/')
       .doc(msg.sent)
       .update({"msg":update_messame});
      
  }

}
