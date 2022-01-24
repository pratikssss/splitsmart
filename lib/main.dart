import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splitsmart/friends/pendingrequests.dart';
import 'package:splitsmart/friends/sendfriendreq.dart';
import 'package:splitsmart/navi.dart';
import 'package:splitsmart/screens/accountscreen.dart';
import 'package:splitsmart/others/cbutton.dart';
import 'package:splitsmart/screens/addfromfriendlist.dart';
import 'package:splitsmart/screens/creategroupscreen.dart';
import 'package:splitsmart/screens/friendscreen.dart';
import 'package:splitsmart/screens/groups_screen.dart';
import 'package:splitsmart/loginpages/loginpage.dart';
import 'package:splitsmart/screens/joingroup.dart';
import 'package:splitsmart/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(const MyApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: Mybottomnavigationbar(),
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.amber,
      ),
      initialRoute: welcomescreen.id,
      routes: {
        //addfromfriendlist.id:(context)=>addfromfriendlist(),
        sendfriendrequest.id: (context) => sendfriendrequest(),
        joingroup.id: (context) => joingroup(),
        loginpage.id: (context) => loginpage(),
        welcomescreen.id: (context) => welcomescreen(),
        accountscreen.id: (context) => accountscreen(),
        groupscreen.id: (context) => groupscreen(),
        Mybottomnavigationbar.id: (context) => Mybottomnavigationbar(),
        creategroupscreen.id: (context) => creategroupscreen(),
        //  hoursspent.id: (context) => hoursspent(),
      },
    );
  }
}
