import 'package:flutter_chat_app/models/user_model.dart';

class Message {
  final bool isMe;
  final String text;
  final String time;
  final String type;
  Message({
    this.isMe,
    this.text,
    this.time,
    this.type="text"
  });

  @override
  String toString() {
    return 'Message { isMe: $isMe, text: $text, time: $time , type: $type}';
  }
}
