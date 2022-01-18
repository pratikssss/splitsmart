import 'package:flutter/material.dart';
import 'package:splitsmart/loginpages/loginpage.dart';
import 'package:splitsmart/others/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinuser;

class creategroupscreen extends StatefulWidget {
  static const String id = 'creategrp';

  @override
  _creategroupscreenState createState() => _creategroupscreenState();
}

class _creategroupscreenState extends State<creategroupscreen> {
  final _auth = FirebaseAuth.instance;
  late String grpname;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splitsmart'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            onChanged: (value) {
              //Do something with the user input.
              grpname = value;
            },
            decoration:
                kinputdecoration.copyWith(hintText: 'Enter your group name'),
          ),
          TextButton(
            onPressed: () {
              //  messagetextcontroller.clear();
              //Implement send functionality.
              messagetextcontroller.clear();
              //Implement send functionality.
              _firestore.collection('users').add({
                'groupname': grpname,
                'sender': loggedinuser!.email,
                'messageTime': DateTime.now(),
              });
            },
            child: Text(
              'Create',
              style: kSendButtonTextStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              //  messagetextcontroller.clear();
              //Implement send functionality.
              Navigator.pushNamed(context, loginpage.id);
            },
            child: Text(
              'back',
              style: kSendButtonTextStyle,
            ),
          ),
        ],
      )),
    );
  }
}
