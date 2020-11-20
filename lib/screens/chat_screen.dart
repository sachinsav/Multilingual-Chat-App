import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/database.dart';
import 'package:flutter_chat_app/models/curuser.dart';

var sendermob,messages;
class ChatScreen extends StatefulWidget {
  final sender_mob;
  ChatScreen(this.sender_mob){
    sendermob = sender_mob;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {
  UserRepo dbmethod = new UserRepo();
  CurUser currentUser = new CurUser();
  Stream chatstream;
  @override
  void initState(){
    initchat();
  }
  void initchat() async{
    //var ttmp = await UserRepo().FetchChat("1234", "12345");
    dbmethod.getChat(currentUser.mob,currentUser.mob2).then((value){
      setState(() {
        print("getchat chatstream");
        chatstream = value;
        print(chatstream.toString());
      });
    });
    // setState(() {
    //   messages = ttmp;
    //   print("async called");
    // });
  }


  _chatBubble(String message, bool isMe) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            key: UniqueKey(),
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  _sendMessageArea() {
    final cur_text = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: cur_text,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              String cur_msg = cur_text.text;
              print(cur_msg);
              await UserRepo().AddChat(currentUser.mob, currentUser.mob2,cur_msg);
              cur_text.clear();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: User.dic_mob[sendermob],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              TextSpan(text: '\n'),
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body:
      Column(
        children: <Widget>[
          Expanded(
            child:
            StreamBuilder(
          stream: chatstream,
          builder: (context,snapshot){
                return snapshot.hasData?ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(20),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String message = snapshot.data.documents[index]["msg"];
                    final bool isMe = snapshot.data.documents[index]["user"] == "u1";
                    print(message);
                    print("inside builder");
                    return _chatBubble(message, isMe);
                  },
                ):Center(child: const CircularProgressIndicator());
        },
      ),

          ),
          _sendMessageArea(),
        ],
      )
    );
  }
}
