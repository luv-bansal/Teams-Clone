import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/widgets/meeting_message_tile.dart';
import 'package:teams_clone/services/meeting_chat_methods.dart';
import 'package:teams_clone/utils/utilities.dart';

class MeetingChat extends StatefulWidget {
  final User user;
  final String channelId;

  MeetingChat({required this.user, required this.channelId});

  @override
  _MeetingChatState createState() => _MeetingChatState();
}

class _MeetingChatState extends State<MeetingChat> {


  MeetingChatMethods meetingChatMethods = MeetingChatMethods();

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
      body: Column(
          children: <Widget>[
            Expanded(child: _chatMessages()),
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
                      
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [TextField(
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
                        ]
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
            ),
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
        onEmojiSelected: (catagoty, emoji) {
          setState(() {
          });
          messageEditingController
            ..text += emoji.emoji
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: messageEditingController.text.length));
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
            buttonMode: ButtonMode.MATERIAL));
  }
  _onBackspacePressed() {
    messageEditingController
      ..text = messageEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageEditingController.text.length));
  }
}
