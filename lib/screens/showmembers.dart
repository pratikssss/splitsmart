import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:splitsmart/others/roundedbutton.dart';
import 'package:splitsmart/screens/moneydist.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;

class showmembers extends StatefulWidget {
  static const String id = 'showmember';
  String iid;
  showmembers(this.iid);
  @override
  _showmembersState createState() => _showmembersState(this.iid);
}

class _showmembersState extends State<showmembers> {
  final _auth = FirebaseAuth.instance;
  late String grpname;
  final CollectionReference grouplist =
      FirebaseFirestore.instance.collection('group');
  String iid;
  _showmembersState(this.iid);
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
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return moneydist(iid, ans);
              }));
            },
            child: Text('Split with few members'),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Split with all members'),
          )
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
                    final hh = namebubble(s);
                    names.add(hh);
                  } else if (amounts > 0) {
                    String s = '';
                    s += '$opponent owes you $amtt Rs';
                    final hh = namebubble(s);
                    names.add(hh);
                  } else {
                    String s = '';
                    String abc = '';
                    for (int h = 1; h < amtt.length; h++) abc += amtt[h];
                    s += 'You owe $opponent  $abc Rs';
                    final hh = namebubble(s);
                    names.add(hh);
                  }
                }
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

class namebubble extends StatelessWidget {
  late String pp;
  namebubble(this.pp);

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
            child: Text(
              pp,
              style: TextStyle(color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }
}
