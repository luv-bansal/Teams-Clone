import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderId;
  String? receiverId;
  String? type = 'text';
  String? message;
  Timestamp? timestamp;
  String? photoUrl;

  Message(
      {this.senderId,
       this.receiverId,
      this.type : 'text',
      this.message,
      this.timestamp});

  //Will be only called when you wish to send an image
  Message.imageMessage(
      {this.senderId,
      this.receiverId,
      this.message,
      this.type : 'image',
      this.timestamp,
      this.photoUrl});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Message.fromMap( map) {

    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
  }
}
