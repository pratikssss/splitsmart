import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/screens/addfromfriendlist.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;
List ab = [];
String? fid;

class moneydist extends StatefulWidget {
  static const String id = 'moneydist';
  String iid;
  String ans;
  moneydist(this.iid, this.ans);
  @override
  _moneydistState createState() => _moneydistState(this.iid, this.ans);
}

class _moneydistState extends State<moneydist> {
  _moneydistState(this.iid, this.ans);
  final _auth = FirebaseAuth.instance;
  late String grpname;
  String ans;
  var mp = {};
  final CollectionReference grouplist =
      FirebaseFirestore.instance.collection('group');
  String iid;
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

  Future getuserlist(double x, String d, String iid, Map mp) async {
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
        if (ids[i] == iid) {
//          print(iid);
          List bb = itemlist[i]['amount'];
          // for (int i = 0; i < bb.length; i++) print(bb[i]);
          for (int j = 0; j < bb.length; j++) {
            //List mm = [];
            String p = bb[j];
            String maily = '';
            String opponent = '';
            int c = 0;
            int h;
            int k;
            for (k = 0; k < p.length; k++) {
              if (p[k] == ' ') {
                c = 1;
                k++;
                // h=k+1;
                break;
              }
              if (c == 0) {
                maily += p[k];
              }
            }
            for (h = k; h < p.length; h++) {
              if (p[h] == ' ') {
                break;
              }
              opponent += p[h];
            }
            //       print(maily + d);
            if (maily == d) {
              if (mp.containsKey(opponent)) {
                String dd = '';
                for (int k = p.length - 1; k >= 0; k--) {
                  if (p[k] == ' ') {
                    break;
                  }
                  dd += p[k];
                }
                String amtt = '';
                for (int k = dd.length - 1; k >= 0; k--) {
                  amtt += dd[k];
                }
                double pk = double.parse(amtt);
                pk += x;
                String kp = pk.toString();
                String pop = '';
                pop += maily + ' ' + opponent + ' ' + kp;
                bb[j] = pop;
              }
            } else if (opponent == d) {
              if (mp.containsKey(maily)) {
                String dd = '';
                for (int k = p.length - 1; k >= 0; k--) {
                  if (p[k] == ' ') {
                    break;
                  }
                  dd += p[k];
                }
                String amtt = '';
                for (int k = dd.length - 1; k >= 0; k--) {
                  amtt += dd[k];
                }
                double pk = double.parse(amtt);
                pk = pk - x;
                String kp = pk.toString();
                String pop = '';
                pop += maily + ' ' + opponent + ' ' + kp;
                bb[j] = pop;
              }
            }
          }
          updateuserdata1(iid, bb);
          print(mp);
          mp.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splitsmart'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          namestream1(iid),
          TextButton(
            onPressed: () {
              double x = double.parse(ans);
              print(x);
              for (int j = 0; j < ab.length; j++) print(ab[j]);
              int len = ab.length;
              x = x / len;
              print(x);
              for (int i = 0; i < ab.length; i++) mp[ab[i]] = 1;
              ab.clear();
              //  mp.clear();
              getuserlist(x, loggedinuser!.email.toString(), iid, mp);
              Navigator.pop(context);
            },
            child: Text('Lesssgooo'),
          ),
          SizedBox(height: 30),
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
            .collection('group')
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
            if (iid == abc) {
              final pp = i.get('members');
              for (int j = 0; j < pp.length; j++) {
                final hh = namebubble(pp[j]);
                names.add(hh);
              }
              //grps.reversed;
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
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
      children: [
        Material(
          //    borderRadius: BorderRadius.only(
          //      topRight: Radius.circular(30),
          //    bottomLeft: Radius.circular(30),
          //   bottomRight: Radius.circular(30)),
          elevation: 5,
          color: c ? Colors.green.shade400 : Colors.white,
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
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
