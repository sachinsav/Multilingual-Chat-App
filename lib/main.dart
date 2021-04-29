import 'package:flutter/material.dart';
import 'package:flutter_chat_app/provider/userprovider.dart';
import 'package:flutter_chat_app/screens/ContactFetch.dart';
import 'package:flutter_chat_app/screens/login.dart';
import 'package:flutter_chat_app/screens/notification.dart';
import 'package:flutter_chat_app/screens/splashscreen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  //runApp(MyApp());
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: UserProvider.initialize())],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'All Chats',
      // theme: ThemeData(
      //   primaryColor: Color(0xFF01afbd),
      // ),
      home: Splash(),
    ),
  )
  );
}


class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    switch(user.status){
      case Status.Uninitialized:
        return Splash();
      case Status.Authenticated:
        return ContactsPage("1234");//TODO: Not using thats why random value
      // case Status.Authenticating:
      //   return LoginScreen();
      case Status.Unauthenticated:
        return Splash();
      default:
        return Splash();
    }
  }
}



// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'All Chats',
//       theme: ThemeData(
//         primaryColor: Color(0xFF01afbd),
//       ),
//       home: SignUp(),
//     );
//   }
// }
