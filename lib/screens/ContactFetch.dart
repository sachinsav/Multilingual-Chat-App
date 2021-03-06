import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_chat_app/database.dart';
import 'package:flutter_chat_app/models/curuser.dart';
import 'package:flutter_chat_app/provider/userprovider.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:flutter_chat_app/screens/login.dart';
import 'package:flutter_chat_app/screens/profile.dart';
import 'package:flutter_chat_app/screens/setting.dart';
import 'package:flutter_chat_app/screens/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsPage extends StatefulWidget {
  final String mob;
  ContactsPage(this.mob) : super();

  @override
  _ContactsPageState createState() => _ContactsPageState(mob);
}

class _ContactsPageState extends State<ContactsPage> {
  var _contacts;
  String phoneNo;
  _ContactsPageState(this.phoneNo);
  final UserRepo dbmethode = new UserRepo();

  @override
  void initState() {
    print(phoneNo);
    init_User();
    getContacts();
    login_success();
    super.initState();
  }

  //getting contacts from phonebook
  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    await FbNotification().initialise();
    var mobLst = new List();
    for(var e in contacts){
      String mob = e.phones.toList()[0].value.replaceAll(new RegExp(r'\D'), "");
      mobLst.add(mob);
    }
    //get matchiing data from firebase
    var userContact = await dbmethode.getMob(mobLst);
    setState(() {
      _contacts = userContact;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "All Chats",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.offline_bolt, color: Colors.white),
              onPressed: () async {
                user.signOut();
                await logout_success();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
          IconButton(
            icon: _simplePopup(),
            color: Colors.white,
          ),
        ],
      ),
      body: _contacts != null
          ?
      ListView.builder(
        itemCount: _contacts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var contact = _contacts?.elementAt(index);
          return GestureDetector(
              onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(contact['mob']
              ),
            ),
          ),
          child:ListTile(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
            leading:  CircleAvatar(
              child: Text(capitalize(contact['name'][0])),
              backgroundColor: Theme.of(context).accentColor,
            ),
            title: Text(capitalize(contact['name']) ?? ''),
          ),
          );
        },
      )
          : Center(child: const CircularProgressIndicator()),
    );
  }

  Widget _simplePopup() => PopupMenuButton<int>(
    icon: Icon(Icons.more_vert,color: Colors.white,),
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              Text("Profile"),
            ],
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
          },
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              Text("Settings"),
            ],
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Setting()));
          },
        ),
      ),
      // PopupMenuItem(
      //   value: 3,
      //   child: GestureDetector(
      //     child: Row(
      //       children: <Widget>[
      //         Text("LogOut"),
      //       ],
      //     ),
      //     onTap: () async {
      //       await FirebaseAuth.instance.signOut();
      //       Navigator.pop(context);
      //       Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      //       //Logout Function
      //     },
      //   ),
      // ),
    ],
  );

  String capitalize(String str) {
    if (str.length<2){
      return str.toUpperCase();
    }

    try {
      return str.split(" ")
          .map((st) => st[0].toUpperCase() + st.substring(1))
          .join(" ");
    }catch(Exception){
    return str;
    }
  }

  Future<void> login_success() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('islogin', true);
    prefs.setString('mob', phoneNo);
  }
  Future<void> logout_success() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('islogin', false);

  }
  Future<void> getLanguageFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    CurUser.lang = prefs.getString('cur_lang');
    CurUser.language = prefs.getString('cur_language');
  }

  void init_User() {
    CurUser.mob = phoneNo;
    getLanguageFromLocalStorage();
  }

}

