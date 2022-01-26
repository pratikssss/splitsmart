import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/others/buttonnforall.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:splitsmart/others/roundedbutton.dart';
import 'package:splitsmart/screens/addfromfriendlist.dart';
import 'package:splitsmart/screens/moneydist.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;
bool flag = false;
String? owid;
int? len;

class showmembers extends StatefulWidget {
  static const String id = 'showmember';
  String iid;
  bool k;
  //int len;
  showmembers(this.iid, this.k);
  @override
  _showmembersState createState() => _showmembersState(this.iid, this.k);
}

class _showmembersState extends State<showmembers> {
  final _auth = FirebaseAuth.instance;
  late String grpname;
  final CollectionReference grouplist =
      FirebaseFirestore.instance.collection('group');
  String iid;
  bool k;
  _showmembersState(this.iid, this.k);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
    pratik();
    //  check();
  }

  void check() async {
    final gval =
        await FirebaseFirestore.instance.collection('group').doc(iid).get();
    String x = gval.get('leader');
    setState(() {
      if (x == loggedinuser!.uid.toString()) {
        k = true;
      } else {
        k = false;
      }
    });
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

  Future updateuserdata1(String uid, List aa) async {
    return await grouplist.doc(uid).update({'amount': aa});
  }

  Future pratik() async {
    try {
      int c = 0;
      await friendlist.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          String ppp = element.get('owner');
          if (ppp == loggedinuser!.email.toString()) {
            owid = element.id;
            print(owid);
            print(iid);
          }
          // final x = element.data();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future lenfind(String iid) async {
    final gval =
        await FirebaseFirestore.instance.collection('group').doc(iid).get();
    List aa = gval.get('members');
    len = aa.length;
  }

  Future getuserlist(double x, String d, String iid) async {
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
          String mn = itemlist[i]['leader'];
          if (mn == loggedinuser!.uid.toString()) {
            flag = true;
            print('mynameeee');
          }
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
            } else if (opponent == d) {
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
          updateuserdata1(iid, bb);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String ans = '';
  bool showspinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splitsmart'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          // Expanded(child: namestream1(iid)),
          Expanded(child: namestream(iid)),
          TextField(
            //  obscureText: true,
            textAlign: TextAlign.center,
            onChanged: (value) {
              ans = value;
              //Do something with the user input.
            },
            decoration: kinputdecoration.copyWith(hintText: 'Enter the money'),
          ),
          SizedBox(
            height: 3,
          ),
          buttonn('Split with few members', () {
            print(iid);
            print(owid);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return moneydist(iid, ans);
            }));
          }),
          SizedBox(
            height: 3,
          ),
          buttonn(
            'Split with all members',
            () async {
              double x = double.parse(ans);
              await lenfind(iid);
              x = x / len!;
              getuserlist(x, loggedinuser!.email.toString(), iid);
            },
          ),
          SizedBox(
            height: 3,
          ),
          Visibility(
            visible: k ? true : false,
            child:
                buttonn('Add members from your friend list to the group', () {
              // pratik();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return addfromfriendlist(iid, owid!);
                }),
              );
            }),
          ),
        ],
      )),
    );
  }
}

class namestream extends StatelessWidget {
  String? iid;
  namestream(this.iid);
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
              final pp = i.get('amount');
              for (int j = 0; j < pp.length; j++) {
                // final hh = namebubble(pp[j]);
                String maily = '';
                String opponent = '';
                int c = 0;
                int h;
                int k;
                for (k = 0; k < pp[j].length; k++) {
                  if (pp[j][k] == ' ') {
                    c = 1;
                    k++;
                    // h=k+1;
                    break;
                  }
                  if (c == 0) {
                    maily += pp[j][k];
                  }
                }
                for (h = k; h < pp[j].length; h++) {
                  if (pp[j][h] == ' ') {
                    break;
                  }
                  opponent += pp[j][h];
                }
                if (maily == loggedinuser!.email.toString()) {
                  String dd = '';
                  for (int k = pp[j].length - 1; k >= 0; k--) {
                    if (pp[j][k] == ' ') {
                      break;
                    }
                    dd += pp[j][k];
                  }
                  String amtt = '';
                  for (int k = dd.length - 1; k >= 0; k--) {
                    amtt += dd[k];
                  }

                  double amounts = double.parse(amtt);
                  if (amounts == 0) {
                    String s = '';
                    s += 'You are all settled up with $opponent ';
                    final hh = namebubble(s, true);
                    names.insert(0, hh);
                    // names.add(hh);
                  } else if (amounts > 0) {
                    String s = '';
                    s += '$opponent owes you $amtt Rs';
                    final hh = namebubble(s, true);
                    names.insert(0, hh);
                    // names.add(hh);
                  } else {
                    String s = '';
                    String abc = '';
                    for (int h = 1; h < amtt.length; h++) abc += amtt[h];
                    s += 'You owe $opponent  $abc Rs';
                    final hh = namebubble(s, false);
                    names.insert(0, hh);
                    // names.add(hh);
                  }
                }
              }
              //grps.reversed;
            }
          }
          return Expanded(
            child: ListView(
//              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: names,
            ),
          );
        });
  }
}

class namebubble extends StatelessWidget {
  late String pp;
  namebubble(this.pp, this.flag);
  bool flag;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 4,
            ),
            Material(
              //    borderRadius: BorderRadius.only(
              //      topRight: Radius.circular(30),
              //    bottomLeft: Radius.circular(30),
              //   bottomRight: Radius.circular(30)),
              elevation: 5,
              // color: Colors.green.shade300,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Text(
                    pp,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: flag ? Colors.green.shade300 : Colors.red),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
