import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/curuser.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_app/database.dart';
class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreen();
  }
}

class ProfileScreen extends State<Profile>{
  File imageFile;
  dynamic ppic = AssetImage('assets/images/profilePic.jpg');
  final picker = ImagePicker();
  UserRepo dbmethod = new UserRepo();
  bool _status = true,camera_status= false;
  String btn_txt = "Edit";
  var nameTxt = TextEditingController();
  var mobTxt = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    nameTxt.text = CurUser.name;
    mobTxt.text = CurUser.mob;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                      text: "Profile",
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
      ),
      body: ListView(
        children: <Widget>[

        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: new Stack(fit: StackFit.loose, children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          image: CurUser.pic==" "?ppic:NetworkImage(CurUser.pic),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 90.0, right: 100.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 25.0,
                        child: IconButton(
                          icon : Icon(Icons.camera_alt),
                          color: Colors.white,

                          onPressed: (){
                            //gallery
                            if(camera_status) {
                              _showSelectionDialog(context);
                            }

                          },
                        ),
                      )
                    ],
                  )),
            ]),
          ),
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 25.0,),
                          Text(
                            'Name',
                            style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: nameTxt,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,

                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(height: 25.0,),
                          Text(
                            'Mobile Number',
                            style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: mobTxt,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Mobile Number",
                                      ),
                                      enabled: false,
                                      autofocus: false,

                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),),
                _getActionButtons(),
              ],
            ),
          )

        ],
      ),
        ],
      )
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 70.0,left: 70.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text(btn_txt),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if(_status){
                        setState(() {
                          _status = false;
                          btn_txt = "Save";
                          camera_status = true;
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      }
                      else{
                        setState(() {
                          _status = true;
                          btn_txt = "Edit";
                          camera_status = false;
                          CurUser.name = nameTxt.text;

                        });
                          if(imageFile!=null){
                            showAlertDialog(context, "Uploading Profile Image");
                            String imageUrl = await dbmethod.uploadFile(imageFile,path: "ProfilePic");
                            dbmethod.addUser(nameTxt.text, mobTxt.text,pic: imageUrl);
                            Navigator.pop(context);
                            setState(() {
                              CurUser.pic = imageUrl;
                              print("setState");
                              print(CurUser.pic);
                            });

                            imageFile = null;
                          }
                          else{
                            dbmethod.addUser(nameTxt.text, mobTxt.text);
                          }
                      }
                      // setState(() async {
                      //   if(_status){
                      //   _status = false;
                      //   btn_txt = "Save";
                      //   FocusScope.of(context).requestFocus(new FocusNode());
                      //   }
                      //   else{
                      //     _status = true;
                      //     btn_txt = "Edit";
                      //     CurUser.name = nameTxt.text;
                      //     if(imageFile!=null){
                      //       String imageUrl = await dbmethod.uploadFile(imageFile,path: "ProfilePic");
                      //       dbmethod.addUser(nameTxt.text, mobTxt.text,pic: imageFile);
                      //       imageFile = null;
                      //     }
                      //     else{
                      //       dbmethod.addUser(nameTxt.text, mobTxt.text);
                      //     }
                      //   }
                      // });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  void addTofb(String text) {
    //TODO: add name to firebase
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
      if (picture!=null) {
        imageFile = File(picture.path);
      }
    });
    Navigator.of(context).pop(true);

  }

  void _openCamera(BuildContext context) async {
    final picture = await picker.getImage(source:ImageSource.camera);
    this.setState(() {
      if (picture!=null) {
        imageFile = File(picture.path);
        print(imageFile.toString());
        ppic = FileImage(imageFile);
      }
    });
    Navigator.of(context).pop(true);

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
}
