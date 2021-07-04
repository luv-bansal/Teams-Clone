import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/widgets/meeting_message_tile.dart';
import 'package:teams_clone/services/meeting_chat_methods.dart';

class MeetingChat extends StatefulWidget {
  final User user;
  final String channelId;

  MeetingChat({required this.user, required this.channelId});

  @override
  _MeetingChatState createState() => _MeetingChatState();
}

class _MeetingChatState extends State<MeetingChat> {


  MeetingChatMethods meetingChatMethods = MeetingChatMethods();

  @override
  void initState() {
    super.initState();
    meetingChatMethods.getChats(widget.channelId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  late Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

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
                  print((snapshot.data!.docs[index].data() as Map)["message"]);
                  return MessageTile(
                    message:
                        (snapshot.data!.docs[index].data() as Map)["message"],
                    sender:
                        (snapshot.data!.docs[index].data() as Map)["sender"],
                    sentByMe: widget.user.displayName ==
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
        "sender": widget.user.displayName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      meetingChatMethods.sendMessage(widget.channelId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Meeting Chat'),
      ),
      body: Container(
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
      ),
    );
  }
}
