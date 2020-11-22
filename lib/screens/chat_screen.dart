import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/database.dart';
import 'package:flutter_chat_app/models/curuser.dart';
import 'package:flutter_chat_app/screens/setting.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';
var senderMob,messages;
final translator = GoogleTranslator();
class ChatScreen extends StatefulWidget {
  final sender_mob;
  ChatScreen(this.sender_mob){
    senderMob = sender_mob;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {
  UserRepo dbmethod = new UserRepo();
  Stream chatstream;
  @override
  void initState(){
    initchat();
  }
  void initchat() async{
    dbmethod.getChat(CurUser.mob,CurUser.mob2).then((value){
      setState(() {
        print("get chat chatstream");
        chatstream = value;
        print(chatstream.toString());
      });
    });
  }

  _chatBubble(Message msg_obj,bool isSameUser,BuildContext context) {
    if (msg_obj.isMe) {
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
                  msg_obj.text,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          !isSameUser
          ?Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                msg_obj.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          )
              :Container(),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
      GestureDetector(
        key: UniqueKey(),
        onTap: () async {
          //String trans_txt = await msg_obj.translate(to: 'en').toString();
          translator
              .translate(msg_obj.text, to: CurUser.lang).then((res){
              final bar = SnackBar(content: Text(res.toString()),
              duration: Duration(seconds: 5),
                action: SnackBarAction(
                label: "Hide",
                onPressed: (){

                },
              ),);
            Scaffold.of(context).showSnackBar(bar);
          });

        print(msg_obj);
        },
        child:
            Container(
            alignment: Alignment.topLeft,
            child:
              Container(
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
                msg_obj.text,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            ),
          ),
          !isSameUser
              ?Row(
              children: <Widget>[
              Text(
                msg_obj.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          )
              :Container(),
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
              String cur_msg = cur_text.text.trim();
              if(cur_msg!="") {
                print(cur_msg);
                await dbmethod.addChat(
                    CurUser.mob, CurUser.mob2, cur_msg);
                cur_text.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String prev_user;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: User.dic_mob[senderMob],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ],
        ),

        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Setting()));
            },
          )
        ],
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
                    final String cur_user = snapshot.data.documents[index]["user"];
                    var timestamp = snapshot.data.documents[index]["createdAt"];

                    final bool isMe =  cur_user == "u1";
                    final bool isSameUser = prev_user==cur_user;
                    prev_user = cur_user;
                    final String time = DateFormat.jm().format(timestamp.toDate());
                    Message msg_obj = new Message(isMe: isMe,text: message,time: time);
                    print(msg_obj);
                    return _chatBubble(msg_obj,isSameUser,context);
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
