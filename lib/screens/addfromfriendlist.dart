import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/friends/pendingrequests.dart';
import 'package:splitsmart/others/buttonnforall.dart';
import 'package:splitsmart/screens/addfromfriendlist.dart';
import 'package:splitsmart/screens/showmembers.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;
List ab = [];
final _auth = FirebaseAuth.instance;
late String grpname;
final CollectionReference friendlist =
    FirebaseFirestore.instance.collection('friendz');
final CollectionReference grouplist =
    FirebaseFirestore.instance.collection('group');

class addfromfriendlist extends StatefulWidget {
  static const String id = 'addfrom';
  String iid;
  String owid;
  addfromfriendlist(this.iid, this.owid);
  @override
  _addfromfriendlistState createState() =>
      _addfromfriendlistState(this.iid, this.owid);
}

class _addfromfriendlistState extends State<addfromfriendlist> {
  _addfromfriendlistState(this.iid, this.owid);
  String iid;
  String owid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  Future a1(String uid, List aa) async {
    return await grouplist.doc(uid).update({'members': aa});
  }

  Future a2(String uid, List aa) async {
    return await grouplist.doc(uid).update({'amount': aa});
  }

  Future updatetrans(String gid) async {
    try {
      //print(ab);
      // print('klkllklklklklklk');
      final gval =
          await FirebaseFirestore.instance.collection('group').doc(gid).get();
      List mem = gval.get('members');
      List money = gval.get('amount');
      Map mp = new Map();
      for (int i = 0; i < mem.length; i++) {
        mp[mem[i]] = 1;
      }
      for (int i = 0; i < ab.length; i++) {
        String d = ab[i];
        // print(d);
        if (!mp.containsKey(d)) {
          for (int j = 0; j < mem.length; j++) {
            String pq = mem[j] + ' ' + d + ' ' + '0';
            String qp = d + ' ' + mem[j] + ' ' + '0';
            money.add(pq);
            money.add(qp);
          }
          a2(gid, money);
          mem.add(d);
          a1(gid, mem);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) loggedinuser = user;
    } catch (e) {
      print(e);
    }
  }

  Future updateuserdata12(String uid, List aa) async {
    return await grouplist.doc(uid).update({'members': aa});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splitsmart'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 2,
          ),
          const Text(
            'Your Friends',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          SizedBox(height: 3),
          namestream1(owid),
          buttonn(
            'Add',
            () async {
              await updatetrans(iid);

              //print(aa);
              ab.clear();

              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 3,
          ),
        ],
      )),
    );
  }
}

class namestream1 extends StatelessWidget {
  String? iid;
  namestream1(this.iid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('friendz')
            .orderBy('ttime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          List<namebubble> names = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final x = snapshot.data!.docs;
          for (var i in x) {
            final abc = i.id;
            if (owid == abc) {
              final pp = i.get('friends');
              for (int j = 0; j < pp.length; j++) {
                final hh = namebubble(pp[j]);
                if (names.length != 0) {
                  names.insert(0, hh);
                } else {
                  names.add(hh);
                }
                // names.add(hh);
              }
              //grps.reversed;
            }
          }
          return Expanded(
            child: ListView(
              //reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: names,
            ),
          );
        });
  }
}

class namebubble extends StatefulWidget {
  late String pp;
  namebubble(this.pp);

  @override
  State<namebubble> createState() => _namebubbleState(this.pp);
}

class _namebubbleState extends State<namebubble> {
  bool c = false;
  String pp;
  _namebubbleState(this.pp);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          //    borderRadius: BorderRadius.only(
          //      topRight: Radius.circular(30),
          //    bottomLeft: Radius.circular(30),
          //   bottomRight: Radius.circular(30)),
          elevation: 5,
          color: c ? Color(0XFF26D6DA) : Colors.white,
          //color: c ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              onPressed: () {
                setState(() {
                  if (c == false) {
                    c = true;
                    ab.add(pp);
                  } else {
                    c = false;
                    ab.remove(pp);
                  }
                });
              },
              child: Text(
                widget.pp,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
