import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/ContactFetch.dart';
import 'package:flutter_chat_app/screens/notification.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'All Chats',
      theme: ThemeData(
        primaryColor: Color(0xFF01afbd),
      ),
      home: ContactsPage(),
    );
  }
}
