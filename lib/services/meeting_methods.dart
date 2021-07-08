import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teams_clone/models/meeting.dart';
import 'package:teams_clone/models/user.dart';

class MeetingMethods {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('meetings');

  Future<bool> makeCall({required Meeting meeting}) async {
    try {
      Map<String, dynamic> dialledMap = meeting.toMap(meeting);

      await callCollection.doc(meeting.channelId).set(dialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addMember(
      {required String channelId, required User member}) async {
    try {
      Map<String, dynamic> toMap(User user) {
        var data = Map<String, dynamic>();
        data['uid'] = user.uid;
        data['name'] = user.displayName;
        data['email'] = user.email;
        data["profile_photo"] = user.photoURL;
        return data;
      }
      // DocumentSnapshot meeting = await callCollection.doc(channelId).get();

      // List x = (meeting.data() as Map)['people'];
      // print(' list of user: $x');
      // x.add(member);

      await callCollection.doc(channelId).update({
        "people": FieldValue.arrayUnion([toMap(member)]),
      });

      // await callCollection.doc().collection(collectionPath);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeMember(
      {required String channelId, required User member}) async {
    try {
      Map<String, dynamic> toMap(User user) {
        var data = Map<String, dynamic>();
        data['uid'] = user.uid;
        data['name'] = user.displayName;
        data['email'] = user.email;
        data["profile_photo"] = user.photoURL;
        return data;
      }
      // DocumentSnapshot meeting = await callCollection.doc(channelId).get();

      // List x = (meeting.data() as Map)['people'];
      // print(' list of user: $x');
      // x.add(member);

      await callCollection.doc(channelId).update({
        "people": FieldValue.arrayRemove([toMap(member)]),
      });

      // await callCollection.doc().collection(collectionPath);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  Future<bool> isMeetingExist({required String channelId}) async {
    try {
      DocumentSnapshot meeting = await callCollection.doc(channelId).get();
      if (meeting.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future fetchUserId(User currUser) async {
    final details =
        await firestoreInstance.collection("users").doc(currUser.uid).get();

    return details['userid'];
  }

  Future fetchUserFromUserid(int userid) async {
    final result = await firestoreInstance
        .collection("users")
        .where("userid", isEqualTo: userid)
        .get();
    print(result.docs.first.data());
    print(userid);
    return result.docs.first.data();
  }

  Future<bool> endCall({required String channelId}) async {
    try {
      await callCollection.doc(channelId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
