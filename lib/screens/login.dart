import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/database.dart';
import 'package:flutter_chat_app/models/customShape.dart';
import 'package:flutter_chat_app/models/responsive_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  UserRepo db;
  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    db = new UserRepo();
     return Scaffold(
       backgroundColor: Colors.white,
       body: SingleChildScrollView(
         child: Container(
                 height: _height,
                 width: _width,
                 margin: EdgeInsets.only(bottom: 5),
                 child: Column(
                   children: <Widget>[
                     Opacity(opacity: 0.88,),
                     clipShape(),
                    SizedBox(height: _height/10),
                    Expanded(
                      flex: 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text('Get Verified',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 30,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: _height/40,),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 25
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'We will send you an ',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20
                                        )
                                    ),

                                    TextSpan(
                                        text: 'One Time Password ',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 22
                                        )
                                    ),

                                    TextSpan(
                                        text: 'on this mobile number ',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20
                                        )
                                    ),
                                  ]
                              ),
                            ),
                          ),

                          SizedBox(height: _height/14,),

                          Container(
                            height: 50,
                            constraints: const BoxConstraints(maxWidth: 500),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10
                            ),
                            child: CupertinoTextField(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25))
                              ),
                              controller: phoneController,
                              clearButtonMode: OverlayVisibilityMode.editing,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(fontSize: 18),
                              maxLength: 10,
                              placeholder: 'Enter your Number',
                              placeholderStyle: TextStyle(color: Colors.blueAccent),
                              prefix: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  "+91",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            //     gradient: LinearGradient(
                            //         colors: <Color>[Colors.teal[400], Colors.tealAccent]
                            //     )
                            // ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10
                            ),
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              onPressed: () async {
                                bool isregister = await db.checkRegister(phoneController.text);

                                if ( isregister && phoneController.text.length == 10) {
                                  print('Routing to otpScreen');
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OTPScreen(phoneController.text)
                                      )
                                  );
                                  Fluttertoast.showToast(msg: 'OTP is sent to your number');
                                }
                                else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Please enter a valid and registered number',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Accept",
                                                  style: TextStyle(fontSize: 15),
                                                )
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }
                              },

                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))
                              ),

                              child: Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                //     gradient: LinearGradient(
                                //         colors: <Color>[Colors.teal[400], Colors.tealAccent]
                                //     )
                                // ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.all(9),
                                      // decoration: const BoxDecoration(
                                      //   borderRadius: const BorderRadius.all(
                                      //       Radius.circular(20)),
                                      //   color: MyColors.primaryBlue,
                                      // ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                   ],
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
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large ? _height/4 : (_medium ? _height/3.75 : _height/3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.blue[200]],
                ),
              ),
            ),
          ),
        ),

        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/4.5 : (_medium? _height/4.25 : _height/4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.blue[200]],
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
          //Center(
            child: Container(
              constraints: BoxConstraints(maxHeight: 300),
              margin: const EdgeInsets.symmetric(
                  horizontal: 8),
              child: Image.asset(
                'assets/images/logoR.png',

              ),
            ),
         // ),
          // child: GestureDetector(
          //   onTap: (){
          //     //TODO: Adding a photo
          //     print('Adding a Photo');
          //   },
          //   child: Icon(
          //     Icons.add_a_photo,
          //     size: _large? 40: (_medium? 33: 31),
          //     color: Colors.black12,
          //   ),
          // ),
        ),
      ],
    );
  }


}
