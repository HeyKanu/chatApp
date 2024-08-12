import 'package:cached_network_image/cached_network_image.dart';
import 'package:chet_app/models/chatUser.dart';
import 'package:chet_app/screens/view_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class profile_Dialog extends StatelessWidget {
   profile_Dialog({super.key,required this.user});
    ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 350,
          width: 150,
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CachedNetworkImage(
                                    height: 350,
                                    width: 280,
                                    fit: BoxFit.cover,
                                    imageUrl: user.img,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            CircularProgressIndicator(
                                                value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.person),
                                  ),
            ),
              Container(
                // padding: EdgeInsets.only(left: 20,right: 10),
                alignment: Alignment.center,
               decoration: BoxDecoration( color: Color.fromARGB(255, 255, 255, 255),boxShadow: [BoxShadow(blurRadius: 10, offset: Offset(0, 0.5),color: Colors.black)]),
                height: 40,
                width: 280,
                child: Text(user.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Color.fromARGB(255, 1, 63, 23)),)),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(onPressed: (){
                      Navigator.pop(context);
                      Get.to(()=>View_proFile(Puser: user,));
                    }, icon: Icon(Icons.info_outline,color: Color.fromARGB(255, 1, 63, 23),))),
          ],),
        ),
      ),
    );
  }
}