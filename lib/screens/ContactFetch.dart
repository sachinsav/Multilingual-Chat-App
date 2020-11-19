import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_chat_app/database.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  var _contacts;

  @override
  void initState() {
    getContacts();
    // UserRepo().FetchChat("1234", "12345");
    super.initState();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    var mob_lst = new List();
    for(var e in contacts){
      String mob = e.phones.toList()[0].value.replaceAll(new RegExp(r'\D'), "");
      mob_lst.add(mob);
      print(mob);
    }
    var UserContact = await UserRepo().getMob(mob_lst);
    setState(() {
      _contacts = UserContact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('All Chats')),
      ),
      body: _contacts != null
      //Build a list view of all contacts, displaying their avatar and
      // display name
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
              child: Text(contact['name'][0]),
              backgroundColor: Theme.of(context).accentColor,
            ),
            title: Text(contact['name'] ?? ''),
            //This can be further expanded to showing contacts detail
            // onPressed().
          ),
          );
        },
      )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}