import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingChatMethods {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<void> sendMessage(String channelId, chatMessageData) async {
    await FirebaseFirestore.instance
        .collection('meeting Chat')
        .doc(channelId)
        .collection('messages')
        .add(chatMessageData);
  }

  Future<void> deleteChat(String channelId) async {
    await FirebaseFirestore.instance
        .collection('meeting Chat')
        .doc(channelId)
        .delete();
  }

  // get chats of a particular group
  getChats(String groupId) async {
    return FirebaseFirestore.instance
        .collection('meeting Chat')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}
