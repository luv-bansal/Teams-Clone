import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/message.dart';


class ChatMethods{
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<void> addMessageToDb(Message message) async {
    var map = message.toMap();

    await firestoreInstance
        .collection('messages')
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map);

    await firestoreInstance.collection('messages').doc(message.receiverId).collection(message.senderId!).add(map);
  }


}