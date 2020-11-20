import 'package:flutter_chat_app/models/user_model.dart';

class Message {
  final String sender;
  final String text;


  Message({
    this.sender,
    this.text,

  });
}
List<Message> chats;
setMsgLst(List<Message> temp){
  chats = temp;
}
