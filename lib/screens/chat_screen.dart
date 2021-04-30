import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/Translator.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/database.dart';
import 'package:flutter_chat_app/models/curuser.dart';
import 'package:flutter_chat_app/screens/setting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_app/database.dart' as db;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../Language.dart';

var senderMob,messages;
final translator = GoogleTranslator();
class ChatScreen extends StatefulWidget {
  final sender_mob;
  ChatScreen(this.sender_mob){
    senderMob = sender_mob;
    CurUser.mob2 = senderMob;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {
  File imageFile;
  String parsedtext = '';
  final picker = ImagePicker();
  UserRepo dbmethod = new UserRepo();
  Stream chatstream;

  @override
  void initState() {
    initchat();
  }

  void initchat() async {
    dbmethod.getChat(CurUser.mob, CurUser.mob2).then((value) {
      setState(() {
        print("get chat chatstream");
        chatstream = value;
        print(chatstream.toString());
      });
    });
  }

  showAlertDialog(BuildContext context,String text){
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 10),child:Text(text)),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  _chatBubble(Message msg_obj, bool isSameUser, BuildContext context) {
    if (msg_obj.isMe) {
      return Column(
        children: <Widget>[
          Container(
            key: UniqueKey(),
            alignment: Alignment.topRight,
            child: msg_obj.type == "text" ? Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
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
            ) : Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.80,
              ),
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Image.network(msg_obj.text),
            ),
          ),
          !isSameUser
              ? Row(
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
              : Container(),
        ],
      );
    }
    else {

      // // progress bar
      // var bodyProgress = new Container(
      //   child: new Stack(
      //     children: <Widget>[
      //       new Container(
      //         alignment: AlignmentDirectional.center,
      //         decoration: new BoxDecoration(
      //           color: Colors.white70,
      //         ),
      //         child: new Container(
      //           decoration: new BoxDecoration(
      //               color: Colors.blue[200],
      //               borderRadius: new BorderRadius.circular(10.0)
      //           ),
      //           width: 300.0,
      //           height: 200.0,
      //           alignment: AlignmentDirectional.center,
      //           child: new Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               new Center(
      //                 child: new SizedBox(
      //                   height: 50.0,
      //                   width: 50.0,
      //                   child: new CircularProgressIndicator(
      //                     value: null,
      //                     strokeWidth: 7.0,
      //                   ),
      //                 ),
      //               ),
      //               new Container(
      //                 margin: const EdgeInsets.only(top: 25.0),
      //                 child: new Center(
      //                   child: new Text(
      //                     "loading.. wait...",
      //                     style: new TextStyle(
      //                         color: Colors.white
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );



      return Column(
        children: <Widget>[
          GestureDetector(
            key: UniqueKey(),
            onTap: () async {
              //String trans_txt = await msg_obj.translate(to: 'en').toString();
              if (msg_obj.type == "img") {
                showAlertDialog(context,"Processing");
                var file = await DefaultCacheManager().getSingleFile(msg_obj.text);
                String img_msg = await parsethetext(file);
                Navigator.pop(context);
                final bar = SnackBar(content: Text(img_msg.toString()),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: "Hide",
                    onPressed: () {

                    },
                  ),);
                Scaffold.of(context).showSnackBar(bar);
              }
              else {
                translator
                    .translate(msg_obj.text, to: CurUser.lang).then((res) {
                  final bar = SnackBar(content: Text(res.toString()),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: "Hide",
                      onPressed: () {

                      },
                    ),);
                  Scaffold.of(context).showSnackBar(bar);
                });
              }

              print(msg_obj);
            },
            child:
            Container(
              alignment: Alignment.topLeft,
              child: msg_obj.type == "text" ?
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.80,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
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
              ) : Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.80,
                ),
                padding: EdgeInsets.all(3),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Image.network(msg_obj.text),
              ),
            ),
          ),
          !isSameUser
              ? Row(
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
              : Container(),
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
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () {
              //gallery
              _showSelectionDialog(context);
              print("pressed");
            },
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
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () async {
              String cur_msg = cur_text.text.trim();
              if (cur_msg != "") {
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
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
                builder: (context, snapshot) {
                  return snapshot.hasData ? ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(20),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String message = snapshot.data
                          .documents[index]["msg"];
                      final String cur_user = snapshot.data
                          .documents[index]["user"];
                      var timestamp = snapshot.data
                          .documents[index]["createdAt"];
                      final String type = snapshot.data
                          .documents[index]["type"];

                      final bool isMe = cur_user == "u1";
                      final bool isSameUser = prev_user == cur_user;
                      prev_user = cur_user;
                      final String time = DateFormat.jm().format(
                          timestamp.toDate());
                      Message msg_obj = new Message(
                          isMe: isMe, text: message, time: time, type: type);
                      print(msg_obj);
                      return _chatBubble(msg_obj, isSameUser, context);
                    },
                  ) : Center(child: const CircularProgressIndicator());
                },
              ),

            ),
            _sendMessageArea(),
          ],
        )
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    final picture = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      }
    });

    if (picture != null) {
      showAlertDialog(context, "Uploading Image Please Wait");
      String imageUrl = await dbmethod.uploadFile(imageFile);
      await dbmethod.addChat(
          CurUser.mob, CurUser.mob2, imageUrl, type: "img");
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void _openCamera(BuildContext context) async {
    final picture = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      }
    });


    if (picture != null) {
      showAlertDialog(context, "Uploading Image Please Wait");
      String imageUrl = await dbmethod.uploadFile(imageFile);
      await dbmethod.addChat(
          CurUser.mob, CurUser.mob2, imageUrl, type: "img");
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }


  parsethetext(var imagefile) async {
    // final imagefile = await ImagePicker()
    //     .getImage(source: ImageSource.gallery, maxWidth: 670, maxHeight: 970);

    // prepare the image
    var bytes = Io.File(imagefile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print(img64.toString());

    // send to api
    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64Image": "data:image/jpg;base64,${img64.toString()}",
      "language": "eng"
    };
    var header = {"apikey": '8b52f15aa688957'};
    var post = await http.post(url = url, body: payload, headers: header);

    // get result from api
    var result = jsonDecode(post.body);
    var temp_str;
    try {
      temp_str = result['ParsedResults'][0]['ParsedText'];
      temp_str = await trans(temp_str, codes[CurUser.language]);
    }catch(error){
      print(error);
      temp_str = "Image does not contain any text";
    }
      return temp_str;

  }
}
