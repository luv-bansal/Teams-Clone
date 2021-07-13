import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teams_clone/models/contact.dart';
import 'package:teams_clone/screens/PageView/widgets/contact_view.dart';
import 'package:teams_clone/screens/PageView/widgets/new_chat_button.dart';
import 'package:teams_clone/screens/PageView/widgets/quiet_box.dart';
import 'package:teams_clone/screens/PageView/widgets/user_circle.dart';

import 'package:teams_clone/services/chat_methods.dart';
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
        title: FaIcon(
        FontAwesomeIcons.microsoft
        ),
        leading: Padding(
          padding: const EdgeInsets.only( top: 10, left: 15, bottom: 5),
          child: UserCircle(initials),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
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
          ),

        ],
      ),
      body: ChatListContainer(currUser!.uid),
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
  ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(userId: widget.currentUserId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var contactList = snapshot.data!.docs;
              if (contactList.isEmpty) {
                return QuietBox();
              }
            return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    Contact contact = Contact.fromMap(contactList[index].data() as Map<String, dynamic>);
                    return ContactView(contact: contact,);
                  });

            }
            return Center(child: CircularProgressIndicator());


          }),
    );
  }
}
