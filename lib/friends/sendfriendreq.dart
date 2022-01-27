import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/friends/pendingrequests.dart';
import 'package:splitsmart/others/buttonnforall.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/screens/friendscreen.dart';
import 'package:splitsmart/screens/showmembers.dart';
import 'package:splitsmart/screens/welcome_screen.dart';

var msgcontroller = TextEditingController();
final _firestore = FirebaseFirestore.instance;
User? loggedinuser;
int flag = 0;
final CollectionReference friendlist =
    FirebaseFirestore.instance.collection('friendz');

class sendfriendrequest extends StatefulWidget {
  static const String id = 'sendreq';
  @override
  _sendfriendrequestState createState() => _sendfriendrequestState();
}

class _sendfriendrequestState extends State<sendfriendrequest> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) loggedinuser = user;
    } catch (e) {
      print(e);
    }
  }

  Future updateuserdata(String uid, List aa) async {
    return await friendlist.doc(uid).update({'pendingreq': aa});
  }

  String? ans;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splitsmart'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  TextField(
                    // obscureText: true,
                    controller: msgcontroller,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      ans = value;
                      //Do something with the user input.
                    },
                    decoration:
                        kinputdecoration.copyWith(hintText: 'Enter name'),
                  ),
                  SizedBox(height: 3),
                  buttonn('Send Request', () async {
                    //  int c = 0;
                    await friendlist.get().then((QuerySnapshot) {
                      QuerySnapshot.docs.forEach((element) {
                        String p = element.get('owner');
                        if (p == ans) {
                          List aa = element.get('pendingreq');
                          String uid = element.id;
                          List bb = element.get('friends');
                          if (!aa.contains(loggedinuser!.email.toString()) &&
                              !bb.contains(loggedinuser!.email.toString())) {
                            aa.add(loggedinuser!.email.toString());
                            updateuserdata(uid, aa);
                          }
                        }
                        // final x = element.data();
                      });
                    });
                    msgcontroller.clear();
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
