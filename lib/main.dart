import 'dart:developer';

import 'package:chet_app/screens/splesh.dart';
import 'package:chet_app/state/emojiProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';

void main() async {
  WidgetsFlutterBinding();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await _initialise_firebase();
 await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("13158697-b399-4ee2-b00d-135224169bdd");
 await OneSignal.Notifications.requestPermission(true);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  //     log(
  //         'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
  //         showDialog(
  //       context: navigatorKey.currentState!.overlay!.context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(event.notification.title ?? "Notification"),
  //           content: Text(event.notification.body ?? "No content"),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("OK"),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //     /// Display Notification, preventDefault to not display
  //     event.preventDefault();
  //     /// Do async work
  //     /// notification.display() to display after preventing default
  //     event.notification.display();
  //   });

  runApp(myApp());
}

late Size screenSize;

class myApp extends StatelessWidget {
  const myApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Show_emoji(),)
      ],
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "chatfyt",
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              elevation: 4,
              backgroundColor: Color.fromARGB(255, 6, 30, 54),
              centerTitle: true,
              foregroundColor: Colors.white,
              titleTextStyle: TextStyle(fontSize: 20))),
      home: splesh(),
    ),);
  }
}

_initialise_firebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For Mhowing Message Notification',
    id: 'chatfy',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chatfy',
    visibility: NotificationVisibility.VISIBILITY_PUBLIC,

);

log("result================= $result");
  print("Done...");
}
