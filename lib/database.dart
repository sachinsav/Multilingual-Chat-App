import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
class UserRepo {

  Future<List<Message>> FetchChat(String cur,String sender) async{
    List<Message> chats = [];
    await Firestore.instance.collection("Chats").document(cur).collection(sender).getDocuments().then((_){
      _.documents.forEach((result){
        chats.add(Message(
          sender: result.data.keys.toList()[0],
          text: result.data.values.toList()[0]
        ));
        print(result.data);
      });
    });
    print("hii");
    setMsgLst(chats);
    return chats;
  }
  Future<void> addUser(String fullName, String mob) async{
    final Firestore firestore = Firestore();
    final uid = "uid1234";
    // await firestore.settings(timestampsInSnapshotsEnabled: true);
    print("adduser called");
    // Call the user's CollectionReference to add a new user
    Firestore.instance
        .collection('User').document(uid)
        .setData({
          "name": fullName,
          "mob": mob,
        });
  }
  Future<List> getMob(var mob_lst) async{
    final uid = "uid1234";
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