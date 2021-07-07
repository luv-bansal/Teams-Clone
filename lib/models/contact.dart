import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  late String uid;
  late Timestamp addedOn;

  Contact({
    required this.uid,
    required this.addedOn,
  });

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'];
    this.addedOn = mapData["added_on"];
  }
}
