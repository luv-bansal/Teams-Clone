import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teams_clone/screens/chatScreens/chat_screen.dart';
import 'package:teams_clone/screens/loading.dart';
import 'package:teams_clone/utils/utilities.dart';

class AllMembers extends StatefulWidget {
  final String channelId;
  AllMembers({required this.channelId});

  @override
  _AllMembersState createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
  bool loading = true;
  Widget temp = Container();

  User currUser = FirebaseAuth.instance.currentUser!;

  messagePrivately(context, receiver) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: blackColor,
        builder: (context) {
          return Container(
            height: (MediaQuery.of(context).size.height) * 0.35,
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
                          "",
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
                leading: Icon(Icons.messenger_sharp),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen(receiver: receiver);
                  }));
                },
                title: Text('Message Privately'),
              )),
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    allMembers(widget.channelId).then((value) {
      setState(() {
        print('done');
        loading = false;
        temp = value;
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Members"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
        ],
      ),
      body: loading ? Loading() : temp,
    );
  }

  Future<Widget> allMembers(channelId) async {
    var x = await FirebaseFirestore.instance
        .collection('meetings')
        .doc(channelId)
        .get();
    return ListView.builder(
        itemCount: (x.data() as Map<String, dynamic>)['people'].length,
        itemBuilder: (context, index) {
          var member =
              (x.data() as Map<String, dynamic>)['people'][index] as Map;
          // print(member);
          return ListTile(
            onTap: () {
              currUser.uid != member['uid'] ? messagePrivately(context, member) : {};
            },
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(member['profile_photo']),
            ),
            title: Text(member['name']),
          );
        });
  }
}
