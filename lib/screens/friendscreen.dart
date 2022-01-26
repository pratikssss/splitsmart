import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/friends/pendingrequests.dart';
import 'package:splitsmart/friends/sendfriendreq.dart';
import 'package:splitsmart/others/buttonnforall.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:splitsmart/others/reusable.dart';
import 'package:splitsmart/screens/showmembers.dart';
import 'package:splitsmart/screens/welcome_screen.dart';
import 'accountscreen.dart';
import 'groups_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;
String? iiid;

class friendscreen extends StatefulWidget {
  static const String id = 'friendscreen';

  @override
  State<friendscreen> createState() => _friendscreenState();
}

class _friendscreenState extends State<friendscreen> {
  final _auth = FirebaseAuth.instance;
  late String grpname;
  late String membername;
  final CollectionReference frienlist =
      FirebaseFirestore.instance.collection('friendz');
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text('SplitSmart'),
          ),
          body: Column(
            children: [
              Text(
                "Your Friends",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0),
              ),
              Expanded(child: friendstream()),
              buttonn('See Pending Requests', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return pendingrequest(iiid!);
                }));
              }),
              SizedBox(
                height: 4,
              ),
              buttonn(
                'Send Friends Requests',
                () {
                  Navigator.pushNamed(context, sendfriendrequest.id);
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
              iiid = abc;
              // print(abc);
              List ls = i.get('friends');
              int dd = ls.length;
              for (int j = 0; j < ls.length; j++) {
                final hh = grpbubble(ls[j]);
                print(ls[j]);
                // String loggedinmail = loggedinuser!.email.toString();
                grps.insert(0, hh);
                //grps.add(hh);
              }
              //grps.reversed;
            }
          }
          return Expanded(
            child: ListView(
              // reverse: true,
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
  late int len;
  late String iiid;
  grpbubble(this.a);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 3,
        ),
        Material(
          //    borderRadius: BorderRadius.only(
          //      topRight: Radius.circular(30),
          //    bottomLeft: Radius.circular(30),
          //   bottomRight: Radius.circular(30)),
          elevation: 5,
          //   color: Colors.green.shade300,
          color: Color(0XFF4FC3F7),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              onPressed: () {
                //Navigator.push(context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                // return showmembers(iid, len);
                // }));
              },
              child: Text(
                a,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
