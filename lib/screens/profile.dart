import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
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
      body: Column(
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
                          image: new ExactAssetImage('assets/images/hulk.jpg'),
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
                        child: new Icon(
                          Icons.camera_alt,
                          color: Colors.white,
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
                  'Parsonal Information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.0,),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
