import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:splitsmart/mybottomnavigation.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:splitsmart/others/roundedbutton.dart';
import 'package:splitsmart/screens/creategroupscreen.dart';
import 'package:splitsmart/screens/groups_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;

class joingroup extends StatefulWidget {
  static const String id = 'joingroup';

  @override
  _joingroupState createState() => _joingroupState();
}

class _joingroupState extends State<joingroup> {
  bool showspinner = false;
  String? gid;
  final _auth = FirebaseAuth.instance;

  final CollectionReference grouplist =
      FirebaseFirestore.instance.collection('group');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  Future updateuserdata(String uid, List aa) async {
    return await grouplist.doc(uid).update({'members': aa});
  }

  Future updateuserdata1(String uid, List aa) async {
    return await grouplist.doc(uid).update({'amount': aa});
  }

  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) loggedinuser = user;
    } catch (e) {
      print(e);
    }

    ///   print(loggedinuser!.email);
//    print(loggedinuser!.phoneNumber);
  }

  Future getuserlist(String gid, String d) async {
    List itemlist = [];
    List ids = [];
    try {
      String k = '';
      int c = 0;
      List ab = [];
      await grouplist.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          ids.add(element.id);
          itemlist.add(element.data());
          c++;
        });
      });
      List mm = [];
      for (var i = 0; i < c; i++) {
        if (ids[i] == gid) {
          List aa = itemlist[i]['members'];
          if (!aa.contains(loggedinuser!.email.toString())) {
            List pq = itemlist[i]['amount'];
            aa.add(d);
            //for (var j = 0; j < aa.length; j++) print(aa[j]);
            String uid = ids[i];
            k = uid;
            updateuserdata(uid, aa);
            for (int j = 0; j < aa.length; j++) {
              if (aa[j] != d) {
                String df = d + ' ' + aa[j] + ' ' + '0';
                pq.add(df);
                String fd = aa[j] + ' ' + d + ' ' + '0';
                pq.add(fd);
              }
            }
            mm = pq;
          }
        }
      }
      updateuserdata1(k, mm);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  gid = value;
                },
                decoration:
                    kinputdecoration.copyWith(hintText: 'Enter group id'),
              ),
              SizedBox(
                height: 8.0,
              ),
              roundedbutton('Join Group', Colors.lightBlueAccent, () async {
                setState(() {
                  showspinner = true;
                });
                getuserlist(gid!, loggedinuser!.email.toString());
                Navigator.pop(context);
                setState(() {
                  showspinner = false;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
