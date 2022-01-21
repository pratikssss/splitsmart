import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;
List ab = [];

class moneydist extends StatefulWidget {
  static const String id = 'moneydist';
  String iid;
  moneydist(this.iid);
  @override
  _moneydistState createState() => _moneydistState(this.iid);
}

class _moneydistState extends State<moneydist> {
  _moneydistState(this.iid);
  final _auth = FirebaseAuth.instance;
  late String grpname;
  final CollectionReference grouplist =
      FirebaseFirestore.instance.collection('group');
  String iid;
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
              for (int j = 0; j < ab.length; j++) print(ab[j]);
            },
            child: Text('Lesssgooo'),
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
