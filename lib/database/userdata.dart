//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  // FirebaseDatabase _firebaseDatabase =FirebaseDatabase.instance;
  // String child = 'users';

  Firestore _firestore = Firestore.instance;
  String collection = 'users';

  void createUser(Map data){
    // TODO: Verify if the user doesn't already exists
   // _firebaseDatabase.reference().child(child).push().set(data);
    _firestore.collection(collection).document(data['userId']).setData(data);
  }
}
