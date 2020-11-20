import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
class UserRepo {

  // Future<List<Message>> FetchChat(String cur,String sender) async{
  //   List<Message> chats = [];
  //   chats.clear();
  //   await Firestore.instance.collection("Chats").document(cur).collection(sender)
  //       .orderBy('createdAt',descending: true).snapshots().listen((QuerySnapshot querySnapshot){
  //     querySnapshot.documents.forEach((document) {
  //       chats.add(Message(
  //         sender: document.data.keys.toList()[0],
  //         text: document.data.values.toList()[0]
  //       ));
  //         });
  //
  //   });
  //
  //   // getDocuments().then((_){
  //   //   _.documents.forEach((result){
  //   //     chats.add(Message(
  //   //       sender: result.data.keys.toList()[0],
  //   //       text: result.data.values.toList()[0]
  //   //     ));
  //   //     print(result.data);
  //   //   });
  //   // });
  //   // print("hii");
  //   setMsgLst(chats);
  //   return chats;
  // }
  getChat(String cur,String sender) async{
    print("getChat has been called");
    return await Firestore.instance.collection("Chats").document(cur).collection(sender)
        .orderBy('createdAt',descending: true).snapshots();
  }
  Future<void> AddChat(String cur,String sender,String text) async{
    await Firestore.instance.collection("Chats").document(cur).collection(sender)
        .add({
        "user":"u1",
        "msg": text,
        "createdAt":Timestamp.now()
        });
    await Firestore.instance.collection("Chats").document(sender).collection(cur)
        .add({
      "user":"u2",
      "msg": text,
      "createdAt":Timestamp.now()
    });
  }
  Future<void> addUser(String fullName, String mob) async{
    final uid = "uid1234";
    print("adduser called");
    Firestore.instance
        .collection('User').document(uid)
        .setData({
          "name": fullName,
          "mob": mob,
        });
  }
  Future<List> getMob(var mob_lst) async{
    print("getmob called");
    var dic = {};
    var UserContact = new List();
    for(var i = 0; i< mob_lst.length; i++){
      await Firestore.instance.collection('User')
          .where('mob', isEqualTo: mob_lst[i])
          .getDocuments()
          .then((result) {
          result.documents.forEach((result) {
            UserContact.add(result.data);
            print(result.data['name']);
            dic[result.data['mob']] = result.data['name'];
            });
          });

    }
    User().setdicmob(dic);
    return UserContact;
  }
}