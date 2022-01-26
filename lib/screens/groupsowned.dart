import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitsmart/others/buttonnforall.dart';
import 'package:splitsmart/screens/addfromfriendlist.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;

class groupsowned extends StatefulWidget {
  const groupsowned({Key? key}) : super(key: key);
  static const String id = 'gown';
  @override
  _groupsownedState createState() => _groupsownedState();
}

class _groupsownedState extends State<groupsowned> {
  final _auth = FirebaseAuth.instance;
  final CollectionReference grouplist =
      FirebaseFirestore.instance.collection('group');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splitsmart'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Text(
            'Groups owned by you and their ids',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          SizedBox(
            height: 3,
          ),
          namestream1(),
        ],
      )),
    );
  }
}

class namestream1 extends StatelessWidget {
  namestream1();
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
            final pp = i.get('leader');
            if (pp == loggedinuser!.uid.toString()) {
              //  final pp = i.get('members');
              //for (int j = 0; j < pp.length; j++) {
              final gn = i.get('groupname');
              final hh = namebubble(gn, abc);
              // names.add(hh);
              names.insert(0, hh);

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
  late String gn;
  late String gid;
  namebubble(this.gn, this.gid);

  @override
  State<namebubble> createState() => _namebubbleState(this.gn, this.gid);
}

class _namebubbleState extends State<namebubble> {
  bool c = false;
  String gn;
  String gid;
  _namebubbleState(this.gn, this.gid);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 4,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.teal.shade900, // red as border color
            ),
          ),
          child: Material(
            //    borderRadius: BorderRadius.only(
            //      topRight: Radius.circular(30),
            //    bottomLeft: Radius.circular(30),
            //   bottomRight: Radius.circular(30)),
            elevation: 5,
            //color: c ? Colors.teal.shade200 : Colors.white,
            //color: c ? Colors.lightBlueAccent : Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Groupname -> ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      gn,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Group id -> ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SelectableText(
                      gid,
                      onTap: () {
                        // print('copied');
                        // you can show toast to the user, like "Copied"
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
