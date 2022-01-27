import 'package:flutter/material.dart';
import 'package:splitsmart/loginpages/loginpage.dart';
import 'package:splitsmart/others/buttonnforall.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitsmart/screens/groups_screen.dart';
import 'package:splitsmart/screens/showmembers.dart';

var msgcontroller = TextEditingController();
final _firestore = FirebaseFirestore.instance;
User? loggedinuser;
final CollectionReference grouplist =
    FirebaseFirestore.instance.collection('group');
bool flag = true;

class creategroupscreen extends StatefulWidget {
  static const String id = 'creategrp';

  @override
  _creategroupscreenState createState() => _creategroupscreenState();
}

class _creategroupscreenState extends State<creategroupscreen> {
  final _auth = FirebaseAuth.instance;
  late String grpname;

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

  Future checkleader(String grpname) async {
    List itemlist = [];
    try {
      int c = 0;
      await grouplist.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          //ids.add(element.id);
          itemlist.add(element.data());
          //c++;
          // final x = element.data();
          // final x=element.data();
        });
      });
      for (int i = 0; i < itemlist.length; i++) {
        String lead = itemlist[i]['leader'];
        String gn = itemlist[i]['groupname'];
        if (gn == grpname && lead == loggedinuser!.uid.toString()) {
          flag = false;
          break;
        }
      }
    } catch (e) {
      print(e);
    }
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
              controller: msgcontroller,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                grpname = value;
              },
              decoration:
                  kinputdecoration.copyWith(hintText: 'Enter your group name'),
            ),
            SizedBox(height: 4),
            buttonn('Create', () async {
              {
                //List<String> op;

                //  messagetextcontroller.clear();
                //Implement send functionality.
                msgcontroller.clear();

                //Implement send functionality.
                //   members.add(loggedinuser!.uid.toString());
                checkleader(grpname);
                if (flag) {
                  _firestore.collection('group').add({
                    'groupname': grpname,
                    'leader': loggedinuser!.uid,
                    'ttime': DateTime.now(),
                    'members': [],
                    'amount': [],
                    //            'messageTime': DateTime.now(),
                  });

                  getuserlist(loggedinuser!.email.toString());
                }
                //     updateuserdata('donnn', "uKZbyPaSVd819mb17IFP");
              }
            }),
            SizedBox(height: 4),
            buttonn('Back', () {
              Navigator.pop(context);
            })
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
            // print(abc);
            List ls = i.get('members');
            int dd = ls.length;
            bool k = false;
            if (qq == loggedinuser!.uid.toString()) {
              k = true;
            }
            final hh = grpbubble(pp, qq, abc, dd, k);
            String loggedinmail = loggedinuser!.email.toString();

            int c = 0;
            for (int j = 0; j < ls.length; j++) {
              if (ls[j] == loggedinmail) {
                c = 1;
                break;
              }
            }
            if (hh == loggedinmail) c = 1;
            if (c == 1) {
              // grps.add(hh);
              if (grps.length != 0) {
                grps.insert(0, hh);
              } else {
                grps.add(hh);
              }
            }

            //grps.reversed;
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

Future removeleader(String iid) async {
  return await grouplist.doc(iid).update({'leader': ''});
}

Future removegroup(String iid) async {
  final gval =
      await FirebaseFirestore.instance.collection('group').doc(iid).get();
  String lead = gval.get('leader');
  if (lead == loggedinuser!.uid.toString()) {
    await removeleader(iid);
  }
  List mem = gval.get('members');
  mem.remove(loggedinuser!.email.toString());

  return await grouplist.doc(iid).update({'members': mem});
}

Future removeamount(String iid) async {
  final gval =
      await FirebaseFirestore.instance.collection('group').doc(iid).get();
  List bb = gval.get('amount');
  List aa = [];
  //List bb = itemlist[i]['amount'];
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
    if (maily == loggedinuser!.email.toString() ||
        opponent == loggedinuser!.email.toString()) {
      aa.add(p);
    }
  }
  for (int i = 0; i < aa.length; i++) bb.remove(aa[i]);
  return await grouplist.doc(iid).update({'amount': bb});
}

class grpbubble extends StatelessWidget {
  late String a;
  late String b;
  late String iid;
  int len;
  bool k;
  grpbubble(this.a, this.b, this.iid, this.len, this.k);

  @override
  Widget build(BuildContext context) {
    //check(iid);
    return Column(
      children: [
        SizedBox(height: 20),
        Material(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(30)),
          elevation: 5,
          color: Color(0xFF80DEEA),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return showmembers(iid, k);
                    }));
                  },
                  child: Text(
                    a,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                color: Colors.tealAccent.shade100,
                child: TextButton(
                  onPressed: () {
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
                                          buttonn('Are you sure', () async {
                                            //func(a);
                                            await removegroup(iid);
                                            await removeamount(iid);
                                            Navigator.pop(context);
                                          }),
                                          SizedBox(height: 5),
                                          buttonn('No', () {
                                            // func1(a);
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
                  child: Text('Leave Group'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
