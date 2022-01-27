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

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;

class pendingrequest extends StatefulWidget {
  static const String id = 'preq';
  String iiid;
  pendingrequest(this.iiid);
  @override
  _pendingrequestState createState() => _pendingrequestState(this.iiid);
}

final CollectionReference friendlist =
    FirebaseFirestore.instance.collection('friendz');

class _pendingrequestState extends State<pendingrequest> {
  final _auth = FirebaseAuth.instance;
  late String grpname;
  late String membername;
  String iiid;
  _pendingrequestState(this.iiid);

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

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SplitSmart'),
        ),
        body: Column(
          children: [
            Text(
              "Pending Friend Requests",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Expanded(child: friendstream()),
          ],
        ));
  }
}

class friendstream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('friendz')
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
            final pp = i.get('owner');
            print(pp);
            //final qq = i.get('leader');
            if (pp == loggedinuser!.email.toString()) {
              final abc = i.id;
              // print(abc);
              List ls = i.get('pendingreq');
              int dd = ls.length;
              for (int j = 0; j < ls.length; j++) {
                final hh = grpbubble(ls[j]);
                print(ls[j]);
                // String loggedinmail = loggedinuser!.email.toString();
                if (grps.length != 0) {
                  grps.insert(0, hh);
                } else {
                  grps.add(hh);
                }
                //  grps.add(hh);
              }
              //grps.reversed;
            }
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: grps,
            ),
          );
        });
  }
}

Future updateuserdata1(String uid, List aa) async {
  return await friendlist.doc(uid).update({'pendingreq': aa});
}

Future updateuserdata(String uid, List aa) async {
  return await friendlist.doc(uid).update({'friends': aa});
}

Future updatefrienddata(String uid, List pq) async {
  return await friendlist.doc(uid).update({'friends': pq});
}

Future updateotherone(String a) async {
  List itemlist = [];
  List ids = [];
  try {
    await friendlist.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        itemlist.add(element.data());
        ids.add(element.id);
      });
    });
    for (int i = 0; i < itemlist.length; i++) {
      String s = itemlist[i]['owner'];
      if (a == s) {
        String fid = ids[i];
        List f = itemlist[i]['friends'];
        f.add(loggedinuser!.email.toString());
        updatefrienddata(fid, f);
        break;
      }
    }
  } catch (e) {}
}

Future func(String a) async {
  final gval =
      await FirebaseFirestore.instance.collection('friendz').doc(iiid).get();
  List aa = gval.get('friends');
  aa.add(a);
  updateuserdata(iiid!, aa);
  updateotherone(a);
  List bb = gval.get('pendingreq');
  bb.remove(a);
  updateuserdata1(iiid!, bb);
}

Future func1(String a) async {
  final gval =
      await FirebaseFirestore.instance.collection('friendz').doc(iiid).get();

  List bb = gval.get('pendingreq');
  bb.remove(a);
  updateuserdata1(iiid!, bb);
}

class grpbubble extends StatelessWidget {
  late String a;
  late String b;
  late String iid;
  late int len;
  grpbubble(this.a);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.lightBlue.shade900, // red as border color
            ),
          ),
          child: Material(
            //    borderRadius: BorderRadius.only(
            //      topRight: Radius.circular(30),
            //    bottomLeft: Radius.circular(30),
            //   bottomRight: Radius.circular(30)),
            elevation: 5,
            color: Colors.blue.shade50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextButton(
                onPressed: () {
                  //Navigator.push(context,
                  //   MaterialPageRoute(builder: (BuildContext context) {
                  // return showmembers(iid, len);
                  // }));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        body: SafeArea(
                          child: Expanded(
                            flex: 1,
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        buttonn('Add Friend', () {
                                          func(a);
                                          Navigator.pop(context);
                                        }),
                                        SizedBox(height: 5),
                                        buttonn('Remove Request', () {
                                          func1(a);
                                          Navigator.pop(context);
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  a,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
