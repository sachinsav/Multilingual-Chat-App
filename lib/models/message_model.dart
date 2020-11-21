import 'package:flutter_chat_app/models/user_model.dart';

class Message {
  final bool isMe;
  final String text;
  final String time;

  Message({
    this.isMe,
    this.text,
    this.time
  });

  @override
  String toString() {
    return 'Message { isMe: $isMe, text: $text, time: $time }';
  }
}
