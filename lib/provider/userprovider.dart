import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/database/userdata.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{

  FirebaseAuth _auth;
  FirebaseUser _user;

  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  UserServices _userServices = UserServices();

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signUp(String name, String email, String phoneNo) async{
    try{
      _status = Status.Authenticating;
      notifyListeners();

      Map<String, dynamic> values = {
        'name': name,
        'email': email,
        'phoneNo': phoneNo
      };
      _userServices.createUser(values);
      return true;
    }
    catch(e){
      print(e.toString());
      return false;
    }
  }

  Future signOut() async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> authentiCated(bool authenticated) async{
    if (authenticated){
      _status = Status.Authenticated;
      _user = user;
    }
    else{
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<void> _onStateChanged(FirebaseUser event) async{
    if (user == null){
      _status = Status.Unauthenticated;
    }
    else{
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}