import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teams_clone/utils/calendar_clients.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  int currId = 1;
  final googleSignIn = GoogleSignIn(scopes: [cal.CalendarApi.calendarScope]);

  bool _isSigningIn = false;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      var httpClient = (await googleSignIn.authenticatedClient())!;
      CalendarClient.calendar = cal.CalendarApi(httpClient);

      var currUser = FirebaseAuth.instance.currentUser;
      print('ID: ${currUser!.uid}');
      // firestoreInstance
      //     .collection("users")
      //     .where('email', isEqualTo: currUser!.email)
      //     .get()
      //     .then((value){
      //       if(value.docs.length ==0) {
      //         firestoreInstance.collection("users").doc(currUser!.uid).set(
      //             {
      //               "name" : currUser.displayName,
      //               "email" : currUser.email,
      //               "username" : Utils.getUsername(currUser.email),
      //               "profilePhotoURL" : currUser.photoURL,
      //             }, SetOptions(merge: true)).then((_){
      //           print("success!");
      //         });
      //       }
      // });

      await firestoreInstance.collection("users").doc(currUser.uid).set({
        "userid": currId,
        "uid": currUser.uid,
        "name": currUser.displayName,
        "email": currUser.email,
        "username": Utils.getUsername(currUser.email),
        "profilePhotoURL": currUser.photoURL,
      }, SetOptions(merge: true)).then((_) {
        currId++;
        print("success!");
      });

      isSigningIn = false;
    }
  }

  Future fetchAllUsers(User currUser) async {
    List userList = [];
    QuerySnapshot querySnapshot =
        await firestoreInstance.collection("users").get();
    // print(querySnapshot.docs.length);
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currUser.uid) {
        userList.add(querySnapshot.docs[i].data());
      }
    }
    return userList;
  }

  Future getUserDetailsById(uid) async {
    DocumentSnapshot documentSnapshot =
        await firestoreInstance.collection("users").doc(uid).get();
    return documentSnapshot.data() as Map;
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
