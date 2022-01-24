import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/friends/pendingrequests.dart';
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
              "Pending ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                grps.add(hh);
              }
              //grps.reversed;
            }
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

Future updateuserdata1(String uid, List aa) async {
  return await friendlist.doc(uid).update({'pendingreq': aa});
}

Future updateuserdata(String uid, List aa) async {
  return await friendlist.doc(uid).update({'friends': aa});
}

Future func(String a) async {
  final gval =
      await FirebaseFirestore.instance.collection('friendz').doc(iiid).get();
  List aa = gval.get('friends');
  aa.add(a);
  updateuserdata(iiid!, aa);
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
                          child: Center(
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    func(a);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Add Friend',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    func1(a);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Remove Requests',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )));
                  },
                );
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
