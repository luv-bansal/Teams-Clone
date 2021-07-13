import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/screens/chatScreens/widget/add_media_modal.dart';
import 'package:teams_clone/screens/chatScreens/widget/receiver_message_layout.dart';
import 'package:teams_clone/screens/chatScreens/widget/sender_message_layout.dart';
import 'package:teams_clone/services/chat_methods.dart';
import 'package:teams_clone/utils/call_utilities.dart';
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
          IconButton(
              onPressed: () {
                CallUtils.dial(from: sender!, to: widget.receiver, context: context);
              },
              icon: Icon(Icons.video_call)),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: messageList()),
          chatControls(),
          showEmojiPicker
              ? SizedBox(
                height: 250,
                child: Container(
                    child: emojiWidgit(),
                  ),
              )
              : Container()
        ],
      ),
    );
  }

  emojiWidgit() {
    return EmojiPicker(
       
      onEmojiSelected: (catagoty , emoji) {
        setState(() {
          isWriting = true;
        });
   textEditingController
            ..text += emoji.emoji
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length));
    
      },
      onBackspacePressed: _onBackspacePressed,
          config: const Config(
            columns: 7,
            emojiSizeMax: 32.0,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            initCategory: Category.RECENT,
            bgColor: Color(0xFFF2F2F2),
            indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            iconColorSelected: Colors.blue,
            progressIndicatorColor: Colors.blue,
            backspaceColor: Colors.blue,
            showRecentsTab: true,
            recentsLimit: 28,
            noRecentsText: 'No Recents',
            noRecentsStyle: TextStyle(fontSize: 20, color: Colors.black26),
            categoryIcons: CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL)

    );
  }
  _onBackspacePressed() {
    textEditingController
      ..text = textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
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
                        ? senderLayout(_message, context)
                        : receiverLayout(_message, context)),
              );
            },
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
              child:
                  Stack(alignment: AlignmentDirectional.bottomEnd, children: [
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
                      icon: Icon(Icons.send)),
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


