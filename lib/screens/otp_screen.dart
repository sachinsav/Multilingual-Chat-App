import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/customShape.dart';
import 'package:flutter_chat_app/models/responsive_ui.dart';
import 'package:flutter_chat_app/provider/userprovider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

import 'Contact.dart';
import 'ContactFetch.dart';

class OTPScreen extends StatefulWidget {

  final String phoneNo;
  OTPScreen(this.phoneNo);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  String _verificationCode;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      key: _scaffoldkey,
      body: Column(
        children: <Widget>[
          Opacity(opacity: 0.88,),
          clipShape(),
          Container(
            height: _height/5,
            margin: EdgeInsets.only(top: 50, left: 30, right: 30),
            child: Center(
              child: Text(
                'Enter 6 digit Verification code sent on +91${widget.phoneNo}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: Colors.black45),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 50.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(5)
              ),
              selectedFieldDecoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(5)
              ),
              followingFieldDecoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(5)
              ),
              pinAnimationType: PinAnimationType.fade,
              //autovalidateMode: false,
              onSubmit: (pin) async{
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.getCredential(
                      verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                     bool authenticated = true;
                     user.authentiCated(authenticated);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ContactsPage()),
                              (route) => false);
                    }
                  }
                  );
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        'Invalid OTP',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      backgroundColor: Colors.black26,
                      elevation: 6.0,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      )));
                  bool authenticated = false;
                  user.authentiCated(authenticated);
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phoneNo}',
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Fluttertoast.showToast(msg: 'Verification Successful');
              print('Authentication successful');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ContactsPage()),
                      (route) => false);
            }
          });
        },
        verificationFailed: (AuthException e) {
          Fluttertoast.showToast(msg: 'Verification Failed');
          print(e.message);
        },
        codeSent: (String verficationID, [int resendToken]) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
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

        // Container(
        //   height: _height / 4,
        //   margin: EdgeInsets.only(top: _large? _height/25 : (_medium? _height/17 : _height/12.5)),
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //       boxShadow: [
        //         BoxShadow(
        //             spreadRadius: 0.0,
        //             color: Colors.black26,
        //             offset: Offset(1.0, 10.0),
        //             blurRadius: 20.0
        //         )
        //       ],
        //       color: Colors.white,
        //       shape: BoxShape.circle
        //   ),
        //   //Center(
        //   child: Container(
        //     constraints: BoxConstraints(maxHeight: 300),
        //     margin: const EdgeInsets.symmetric(
        //         horizontal: 8),
        //     child: Image.asset(
        //       'assets/images/1.png',
        //       color: Colors.black38,
        //     ),
        //   ),
        //   // ),
        //   // child: GestureDetector(
        //   //   onTap: (){
        //   //     //TODO: Adding a photo
        //   //     print('Adding a Photo');
        //   //   },
        //   //   child: Icon(
        //   //     Icons.add_a_photo,
        //   //     size: _large? 40: (_medium? 33: 31),
        //   //     color: Colors.black12,
        //   //   ),
        //   // ),
        // ),
      ],
    );
  }

}


