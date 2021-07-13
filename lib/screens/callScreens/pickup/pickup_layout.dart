import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/call.dart';
import 'package:teams_clone/screens/callScreens/pickup/pickup_screen.dart';
import 'package:teams_clone/services/call_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({required this.scaffold});

  User? currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid: currUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call = Call.fromMap(snapshot.data!.data() as Map);

          if (!call.hasDialled!) {
            return PickupScreen(call: call);
          }
          return scaffold;
        }
        return scaffold;
      },
    );
  }
}
