import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/Contact.dart';
import 'package:flutter_chat_app/screens/ContactFetch.dart';
import './screens/home_screen.dart';
import 'package:flutter_chat_app/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
