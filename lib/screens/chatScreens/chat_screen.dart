import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/services/chat_methods.dart';
import 'package:teams_clone/utils/utilities.dart';

class ChatScreen extends StatefulWidget {
  final receiver;
  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isWriting = false;

  User? sender = FirebaseAuth.instance.currentUser;

  ChatMethods chatMethods = ChatMethods();

  TextEditingController textEditingController = TextEditingController();

  FocusNode textFieldFocus = FocusNode();

  bool showEmojiPicker = false;

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.receiver['name']),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: messageList()),
          chatControls(),
          showEmojiPicker
              ? Container(
                  child: emojiWidgit(),
                )
              : Container()
        ],
      ),
    );
  }
  emojiWidgit() {
    return EmojiPicker(
      bgColor: separatorColor,
      indicatorColor: color,
      rows: 5,
      columns: 8,
      onEmojiSelected: (emoji, catagoty) {
                setState(() {
          isWriting = true;
        });

        textEditingController.text = textEditingController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(sender!.uid)
            .collection(widget.receiver['uid'])
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            reverse: true,
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Message _message =
                  Message.fromMap(snapshot.data!.docs[index].data());
              return Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Container(
                    alignment: _message.senderId == sender!.uid
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: _message.senderId == sender!.uid
                        ? senderLayout(_message)
                        : receiverLayout(_message)),
              );
            },
          );
        });
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 5),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          message.message!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          message.message!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: blackColor,
        builder: (context) {
          return Container(
            height: (MediaQuery.of(context).size.height) * 0.2,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Schedule Call",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListTile(
                subtitle: Text('Arrange a call and get reminders'),
                leading: Icon(Icons.schedule),
                onTap: () {},
                title: Text('Schedule Call'),
              ))
            ]),
          );
        });
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              addMediaModal(context);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: Stack( alignment: AlignmentDirectional.bottomEnd ,children: [
            TextField(
              focusNode: textFieldFocus,
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              onTap: () {
                hideEmojiContainer();
              },
              controller: textEditingController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: separatorColor,
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                if (!showEmojiPicker) {
                  // keyboard is visible
                  hideKeyboard();
                  showEmojiContainer();
                } else {
                  //keyboard is hidden
                  showKeyboard();
                  hideEmojiContainer();
                }
              },
              icon: Icon(
                Icons.face,
                color: Colors.amber,
              ),
            ),
          ])),
          isWriting
              ? Container(
                  decoration: BoxDecoration(
                    gradient: fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                  icon: Icon(Icons.send)
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  sendMessage() {
    var text = textEditingController.text;
    Message message = Message(
        receiverId: widget.receiver['uid'],
        senderId: sender!.uid,
        type: 'text',
        message: text,
        timestamp: Timestamp.now());
    setState(() {
      isWriting = false;
      textEditingController.text = '';
    });
    chatMethods.addMessageToDb(message);
  }
}