import 'package:flutter/material.dart';
import 'package:splitsmart/loginpages/loginpage.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitsmart/screens/groups_screen.dart';
import 'package:splitsmart/screens/showmembers.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;

class creategroupscreen extends StatefulWidget {
  static const String id = 'creategrp';

  @override
  _creategroupscreenState createState() => _creategroupscreenState();
}

class _creategroupscreenState extends State<creategroupscreen> {
  final _auth = FirebaseAuth.instance;
  late String grpname;
  final CollectionReference grouplist =
      FirebaseFirestore.instance.collection('group');

  // ignore: deprecated_member_use
  List<String> members = [];
  final messagetextcontroller = TextEditingController();
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

    ///   print(loggedinuser!.email);
//    print(loggedinuser!.phoneNumber);
  }

  Future updateuserdata(String uid, List aa) async {
    return await grouplist.doc(uid).update({'members': aa});
  }

  Future getuserlist(String d) async {
    List itemlist = [];
    List ids = [];
    try {
      int c = 0;
      await grouplist.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          ids.add(element.id);
          itemlist.add(element.data());
          c++;
          // final x = element.data();
        });
      });
      for (var i = 0; i < c; i++) {
        if (itemlist[i]['groupname'] == grpname) {
          List aa = itemlist[i]['members'];
          aa.add(d);
          for (var j = 0; j < aa.length; j++) print(aa[j]);
          String uid = ids[i];
          updateuserdata(uid, aa);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Splitsmart'),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(child: grpstream()),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                grpname = value;
              },
              decoration:
                  kinputdecoration.copyWith(hintText: 'Enter your group name'),
            ),
            TextButton(
              onPressed: () {
                //List<String> op;

                //  messagetextcontroller.clear();
                //Implement send functionality.
                messagetextcontroller.clear();

                //Implement send functionality.
                //   members.add(loggedinuser!.uid.toString());
                _firestore.collection('group').add({
                  'groupname': grpname,
                  'leader': loggedinuser!.uid,
                  'ttime': DateTime.now(),
                  'members': [],
                  'amount': [],
                  //            'messageTime': DateTime.now(),
                });
                getuserlist(loggedinuser!.email.toString());
                //     updateuserdata('donnn', "uKZbyPaSVd819mb17IFP");
              },
              child: Text(
                'Create',
                style: kSendButtonTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                //  messagetextcontroller.clear();
                //Implement send functionality.
                Navigator.pushNamed(context, groupscreen.id);
              },
              child: Text(
                'back',
                style: kSendButtonTextStyle,
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class grpstream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('group')
            .orderBy('ttime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          List<grpbubble> grps = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final x = snapshot.data!.docs;
          for (var i in x) {
            final pp = i.get('groupname');
            final qq = i.get('leader');
            final abc = i.id;
            print(abc);
            final hh = grpbubble(pp, qq, abc);
            String loggedinmail = loggedinuser!.email.toString();
            List ls = i.get('members');
            int c = 0;
            for (int j = 0; j < ls.length; j++) {
              if (ls[j] == loggedinmail) {
                c = 1;
                break;
              }
            }
            if (hh == loggedinmail) c = 1;
            if (c == 1) grps.add(hh);
            //grps.reversed;
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: grps,
            ),
          );
        });
  }
}

class grpbubble extends StatelessWidget {
  late String a;
  late String b;
  late String iid;
  grpbubble(this.a, this.b, this.iid);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          //    borderRadius: BorderRadius.only(
          //      topRight: Radius.circular(30),
          //    bottomLeft: Radius.circular(30),
          //   bottomRight: Radius.circular(30)),
          elevation: 5,
          color: Colors.green.shade300,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return showmembers(iid);
                }));
              },
              child: Text(
                a,
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
