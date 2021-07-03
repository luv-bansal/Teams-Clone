import 'package:firebase_auth/firebase_auth.dart';

class Userm {
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;

  Userm({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.displayName;
    data['email'] = user.email;
    data["profile_photo"] = user.photoURL;
    return data;
  }

  Userm.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }
}