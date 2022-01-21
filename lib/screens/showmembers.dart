import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splitsmart'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: namestream(iid)),
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
