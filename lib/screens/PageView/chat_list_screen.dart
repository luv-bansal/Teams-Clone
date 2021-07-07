import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/PageView/widgets/new_chat_button.dart';
import 'package:teams_clone/screens/PageView/widgets/user_circle.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/screens/search_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String? name = currUser!.displayName;
    String initials = name!.split(" ")[0][0] + name.split(" ")[1][0];
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        leading: IconButton(
          icon: Icon(Icons.notifications),
          color: Colors.white,
          onPressed: () {},
        ),
        title: UserCircle(initials),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ChatListContainer(currUser!.uid),
      floatingActionButton: NewChatButton(),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;

  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container();
          }),
    );
  }
}
