import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/curuser.dart';
import 'package:flutter_chat_app/models/user_model.dart';
class UserRepo {

  Future<Stream<QuerySnapshot>> getChat(String cur,String sender) async{
    print("getChat has been called");
    return Firestore.instance.collection("Chats").document(cur).collection(sender)
        .orderBy('createdAt',descending: true).snapshots();
  }

  Future<void> addChat(String cur,String sender,String text,{String type="text"}) async{
    await Firestore.instance.collection("Chats").document(cur).collection(sender)
        .add({
        "user":"u1",
        "msg": text,
        "createdAt":Timestamp.now(),
        "type":type
        });
    await Firestore.instance.collection("Chats").document(sender).collection(cur)
        .add({
      "user":"u2",
      "msg": text,
      "createdAt":Timestamp.now(),
      "type":type
    });
  }
  Future<String> uploadFile(File _image,{path = "Chats"}) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference ref = storage.ref().child(path).child("image" + DateTime.now().toString());
    StorageUploadTask uploadTask = ref.putFile(_image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<void> addUser(String fullName, String mob,{pic = " "}) async{
    //TODO: user Id has to add here
    final uid = "uid1234";
    print("add user called");
    Firestore.instance
        .collection('User').document(uid)
        .setData({
          "name": fullName,
          "mob": mob,
          "pic": pic==" "?CurUser.pic:pic
        });
  }


  Future<List> getMob(var mobLst) async{
    var dic = {};
    var userContact = new List();
    for(var i = 0; i< mobLst.length; i++){
      await Firestore.instance.collection('User')
          .where('mob', isEqualTo: mobLst[i])
          .getDocuments()
          .then((result) {
          result.documents.forEach((result) {
            userContact.add(result.data);
            dic[result.data['mob']] = capitalize((result.data['name']));
            });
          });
    }
    User().setdicmob(dic);
    return userContact;
  }

  String capitalize(String str) {
    if (str.length<2){
      return str.toUpperCase();
    }
    return str.split(" ").map((st) => st[0].toUpperCase()+st.substring(1)).join(" ");
  }
}