import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInProvider extends ChangeNotifier {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final googleSignIn = GoogleSignIn();

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
        "uid": currUser.uid,
        "name": currUser.displayName,
        "email": currUser.email,
        "username": Utils.getUsername(currUser.email),
        "profilePhotoURL": currUser.photoURL,
      }, SetOptions(merge: true)).then((_) {
        print("success!");
      });

      isSigningIn = false;
    }
  }

  Future fetchAllUsers(User currUser) async {
    List userList = [];
    QuerySnapshot querySnapshot =
        await firestoreInstance.collection("users").get();
    print(querySnapshot.docs.length);
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currUser.uid) {
        userList.add(querySnapshot.docs[i].data());
      }
    }
    return userList;
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
