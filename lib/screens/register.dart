import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_chat_app/models/customShape.dart';
import 'package:flutter_chat_app/models/responsive_ui.dart';
import 'package:flutter_chat_app/provider/userprovider.dart';
import 'package:flutter_chat_app/screens/login.dart';
import 'package:provider/provider.dart';

import '../database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        key: _key,
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88,), //TODO: add custom appbar as child here
                //SizedBox(height: _height/35,),
                clipShape(),
                form(),
                SizedBox(height: _height/55,),
                acceptTerms(),
                SizedBox(height: _height/22,),
              RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: (){
                  if (_formKey.currentState.validate()){
                    if(checkBoxValue){
                      // TODO: Verify if the user doesn't already exists

                      user.signUp(_name.text, _email.text, _phone.text);
                      new UserRepo().addUser(_name.text, _phone.text);

                      Fluttertoast.showToast(msg: 'Registration Successful');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                      print('Take me to verification page');
                    }
                    else{
                      Fluttertoast.showToast(msg: 'Accept Terms & Conditions');
                      print('Accept the terms');
                    }
                  }
                  else{
                    Fluttertoast.showToast(msg: 'Please enter details');
                    print('Please fill the details');
                  }
                },
                textColor: Colors.white,
                padding: EdgeInsets.all(0.0),
                child: Container(
                  alignment: Alignment.center,
                  width:_large? _width/4 : (_medium? _width/3.75: _width/3.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      gradient: LinearGradient(
                          colors: <Color>[Colors.teal[400], Colors.tealAccent]
                      )
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: _large? 14: (_medium? 12: 10),
                    ),
                  ),
                ),
              ),
                // SizedBox(height: _height/1100,),
                signInTextRow()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape(){
    return Stack(
      children: <Widget>[
        Opacity(
            opacity: 0.75,
          child: ClipPath(
            //TODO: add clipper here
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large ? _height/4 : (_medium ? _height/3.75 : _height/3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400], Colors.tealAccent],
                ),
              ),
            ),
          ),
        ),

        Opacity(
          opacity: 0.5,
          child: ClipPath(
            //TODO: add clipper2 here
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/4.5 : (_medium? _height/4.25 : _height/4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400], Colors.tealAccent],
                ),
              ),
            ),
          ),
        ),

        Container(
          height: _height / 5,
          margin: EdgeInsets.only(top: _large? _height/25 : (_medium? _height/17 : _height/12.5)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 0.0,
                color: Colors.black26,
                offset: Offset(1.0, 10.0),
                blurRadius: 20.0
              )
            ],
            color: Colors.white,
            shape: BoxShape.circle
          ),
           // child: Image.asset(
           //   "assets/images/logo.jpg",
           //   width: 250.0,
           //   height: 200.0,
           // ),
          child: GestureDetector(
            onTap: (){
              //TODO: Adding a photo
              print('Adding a Photo');
              Fluttertoast.showToast(msg: 'Select a picture');
            },
            child: Icon(
              Icons.add_a_photo,
              size: _large? 40: (_medium? 33: 31),
              color: Colors.black12,
            ),
          ),
        ),
      ],
    );
  }

  Widget form(){
    return Container(
      margin: EdgeInsets.only(
          left:_width/ 12.0,
          right: _width / 12.0,
          top: _height / 20.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            //TODO: create the registration form here
            nameField(),
            SizedBox(height: _height/100,),
            mailIdField(),
            SizedBox(height: _height/100,),
            phoneField()
          ],
        ),
      ),
    );
  }

  Widget nameField(){
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 12 : (_medium? 10 : 8),
      child: TextFormField(
        controller: _name,
        keyboardType: TextInputType.text,
        cursorColor: Colors.teal[200],
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.person,
              color: Colors.teal[200],
              size: 20
          ),
          hintText: 'Full Name',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none
          ),
        ),
        // here we validate the input field
        validator: (value){
          if (value.isEmpty){
            return 'Enter Your Name';
          }
          return null;
        },
      ),
    );
  }

  Widget mailIdField(){
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 12 : (_medium? 10 : 8),
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.teal[200],
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.email,
              color: Colors.teal[200],
              size: 20
          ),
          hintText: 'E-mail Address',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none
          ),
        ),
        // here we validate the input field
        validator: (value){
          // ignore: missing_return
          if (value.isNotEmpty) {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            // ignore: missing_return
            RegExp regex = new RegExp(pattern);
            if (!regex.hasMatch(value))
              return 'Enter a valid E-mail Address!!!';
            else
              return null;
            // ignore: missing_return
          }
          return 'Enter an E-mail Address';
        },
      ),
    );
  }

  Widget phoneField(){
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 12 : (_medium? 10 : 8),
      child: TextFormField(
        controller: _phone,
        keyboardType: TextInputType.phone,
        cursorColor: Colors.teal[200],
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.phone_android,
              color: Colors.teal[200],
              size: 20
          ),
          hintText: 'Mobile Number',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none
          ),
        ),
        // here we validate the input field
        validator: (value){
          Pattern pattern = r'^[0-9]';
          RegExp regex = new RegExp(pattern);
          if (value.isEmpty) {
            return "Enter your Phone Number!!!";
          } else if (value.trim().length != 10) {
            return "Enter 10 digits number...";
          } else if (!regex.hasMatch(value)) {
            return "Enter a valid 10 digits number...";
          }
          return null;
          // ignore: missing_return
        },
      ),
    );
  }

  Widget acceptTerms(){
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.teal[400],
              value: checkBoxValue,
              onChanged: (bool newValue){
                setState(() {
                  checkBoxValue = newValue;
                });
              }
              ),
          Text(
            'I accept all terms and conditions',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: _large? 12: (_medium? 11: 10)
            ),
          )
        ],
      ),
    );
  }

  // Widget signupButton(){
  //   final user = Provider.of<UserProvider>(context);
  //
  //   return RaisedButton(
  //     elevation: 0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(30.0),
  //     ),
  //     onPressed: (){
  //       if (_formKey.currentState.validate()){
  //         if(checkBoxValue){
  //           // TODO: Verify if the user doesn't already exists
  //           user.signUp(_name.text, _email.text, _phone.text);
  //           Fluttertoast.showToast(msg: 'Registration Successful');
  //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  //           print('Take me to verification page');
  //         }
  //         else{
  //           Fluttertoast.showToast(msg: 'Accept Terms & Conditions');
  //           print('Accept the terms');
  //         }
  //       }
  //       else{
  //         Fluttertoast.showToast(msg: 'Please enter details');
  //         print('Please fill the details');
  //       }
  //     },
  //     textColor: Colors.white,
  //     padding: EdgeInsets.all(0.0),
  //     child: Container(
  //       alignment: Alignment.center,
  //         width:_large? _width/4 : (_medium? _width/3.75: _width/3.5),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //         gradient: LinearGradient(
  //           colors: <Color>[Colors.teal[400], Colors.tealAccent]
  //         )
  //       ),
  //       padding: const EdgeInsets.all(12.0),
  //       child: Text(
  //         'Register',
  //         style: TextStyle(
  //           fontSize: _large? 14: (_medium? 12: 10),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 45.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              //Navigator.of(context).pop(SIGN_IN);
              print("Routing to verification screen");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              Fluttertoast.showToast(msg: 'Verify your registered number');
            },
            child: Text(
              "LogIn",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.teal[200], fontSize: 17),
            ),
          )
        ],
      ),
    );
  }
}
