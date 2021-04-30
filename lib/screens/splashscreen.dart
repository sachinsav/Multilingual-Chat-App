import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_chat_app/screens/register.dart';

import 'ContactFetch.dart';

class Splash extends StatelessWidget {
  var islogin = false;
  String phoneNo;
  @override
  Widget build(BuildContext context) {
    checklogin();
    setUserMobile();
    return Container(
      //margin: const EdgeInsets.all(10.0),

      child: SplashScreen(
        seconds: 5,
        navigateAfterSeconds: islogin ? ContactsPage(phoneNo) :SignUp(),
        title: new Text('Wait a moment...',textScaleFactor: 1,),
        image: Image.asset(
          'assets/images/logoR.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        loadingText: Text("Loading"),
        photoSize: 160.0,
        loaderColor: Colors.blue[200],
      ),
    );
  }

  Future<void> checklogin() async {
      final prefs = await SharedPreferences.getInstance();
      islogin = prefs.getBool('islogin') ?? false;
      print(islogin?"logeddin":"not log in");
  }
  Future<void> setUserMobile() async {
    final prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString('mob')??"0000000000";

  }
}

