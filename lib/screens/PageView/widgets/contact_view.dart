import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/contact.dart';
import 'package:teams_clone/screens/PageView/widgets/last_message_containter.dart';
import 'package:teams_clone/screens/chatScreens/chat_screen.dart';
import 'package:teams_clone/services/chat_methods.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:teams_clone/utils/utilities.dart';

class ContactView extends StatefulWidget {
  final Contact contact;
  ContactView({required this.contact});
  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: googleSignInProvider.getUserDetailsById(widget.contact.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data;

            return ViewLayout(
              receiver: user,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ViewLayout extends StatelessWidget {
  ChatMethods chatMethods = ChatMethods();
  final receiver;
  ViewLayout({required this.receiver});
  User? sender = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: receiver,
            ),
          )),
      title: Text(
        (receiver != null ? receiver['name'] : null) != null
            ? receiver['name']
            : "..",
        style: TextStyle(color: Colors.white, fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: chatMethods.fetchLastMessage(senderId: sender!.uid, receiverId: receiver['uid']),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(receiver['profilePhotoURL']),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onlineDotColor,
                    border: Border.all(color: blackColor, width: 2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
