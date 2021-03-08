import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FbNotification {
  final FirebaseMessaging fbmsg = FirebaseMessaging();
  Future initialise() async {
    if(Platform.isIOS){
      fbmsg.requestNotificationPermissions(IosNotificationSettings());
    }
    fbmsg.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("Hello");
          print('onMessage: $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },
    );
  }
}