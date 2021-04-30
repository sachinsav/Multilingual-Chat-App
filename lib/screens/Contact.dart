import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/ContactFetch.dart';
import 'package:permission_handler/permission_handler.dart';



class SeeContactsButton extends StatelessWidget {
  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        _getThingsOnStartup().then((value) async {
          print('Async done');
          final PermissionStatus permissionStatus = await _getPermission();
          if (permissionStatus == PermissionStatus.granted) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ContactsPage("1234")));//TODO: Not using this class now so just random value
          } else {
            //If permissions have been denied show standard cupertino alert dialog
            showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Permissions error'),
                  content: Text('Please enable contacts access '
                      'permission in system settings'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
          }
        });
      },
      child: Container(),
    );

    // return RaisedButton(
    //   onPressed: () async {
    //     final PermissionStatus permissionStatus = await _getPermission();
    //     if (permissionStatus == PermissionStatus.granted) {
    //       Navigator.push(
    //           context, MaterialPageRoute(builder: (context) => ContactsPage()));
    //     } else {
    //       //If permissions have been denied show standard cupertino alert dialog
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) => CupertinoAlertDialog(
    //             title: Text('Permissions error'),
    //             content: Text('Please enable contacts access '
    //                 'permission in system settings'),
    //             actions: <Widget>[
    //               CupertinoDialogAction(
    //                 child: Text('OK'),
    //                 onPressed: () => Navigator.of(context).pop(),
    //               )
    //             ],
    //           ));
    //     }
    //   },
    //   child: Container(child: Text('See Contacts')),
    // );
  }
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({@required this.onInit, @required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}
class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if(widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}