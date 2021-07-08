import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/widgets/meeting_message_tile.dart';
import 'package:teams_clone/services/teams_methods.dart';

class Chatwidget extends StatefulWidget {
  late final String groupId;
  late final String userName;
  late final String groupName;

  Chatwidget(
      {required this.groupId, required this.userName, required this.groupName});

  @override
  _ChatwidgetState createState() => _ChatwidgetState();
}

class _ChatwidgetState extends State<Chatwidget> {
  late Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  TeamsMethods teamsMethods = TeamsMethods();
  User user = FirebaseAuth.instance.currentUser!;


  @override
  void initState() {
    super.initState();
    _chats = FirebaseFirestore.instance
        .collection('Teams')
        .doc(widget.groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();

  }

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        }
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // print((snapshot.data!.docs[index].data() as Map)["message"]);
                  return MessageTile(
                    message:
                        (snapshot.data!.docs[index].data() as Map)["message"],
                    sender:
                        (snapshot.data!.docs[index].data() as Map)["sender"],
                    sentByMe: user.displayName ==
                        (snapshot.data!.docs[index].data() as Map)["sender"],
                  );
                })
            : Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": user.displayName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      teamsMethods.sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }
}
