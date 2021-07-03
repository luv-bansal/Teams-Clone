import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/call.dart';
import 'package:teams_clone/screens/callScreens/call_screen.dart';
import 'package:teams_clone/services/call_methods.dart';
import 'package:teams_clone/utils/utilities.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({required User from, required to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.displayName!,
      callerPic: from.photoURL!,
      receiverId: to['uid'],
      receiverName: to['name'],
      receiverPic: to['profilePhotoURL'],
      channelId: getRandomString(10),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
