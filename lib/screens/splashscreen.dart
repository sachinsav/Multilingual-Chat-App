import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_chat_app/screens/register.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.all(10.0),
      child: SplashScreen(
        seconds: 5,
        navigateAfterSeconds: SignUp(),
        title: new Text('Wait a moment...',textScaleFactor: 1,),
        image: Image.asset(
          'assets/images/logo.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        loadingText: Text("Loading"),
        photoSize: 185.0,
        loaderColor: Colors.teal,
      ),
    );
  }
}

