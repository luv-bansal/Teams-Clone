import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/teamsScreen/widget/bottom_modal_options.dart';
import 'package:teams_clone/screens/teamsScreen/widget/chat.dart';
import 'package:teams_clone/screens/teamsScreen/widget/join_now_widget.dart';
import 'package:teams_clone/utils/utilities.dart';

class TeamsChatScreen extends StatefulWidget {
  late final String groupId;
  late final String userName;
  late final String groupName;

  TeamsChatScreen(
      {required this.groupId, required this.userName, required this.groupName});

  @override
  _TeamsChatScreenState createState() => _TeamsChatScreenState();
}

class _TeamsChatScreenState extends State<TeamsChatScreen> {

  User user = FirebaseAuth.instance.currentUser!;

  String? meetingCode;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: whiteColor)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  meetingCode = getRandomString(10);
                });
                
                showWidgitFunc(context, meetingCode!, user, widget.groupId, widget.groupName);
              },
              icon: Icon(Icons.video_camera_back)),
          IconButton(
              onPressed: () {
                addOptionsModal(
                    context, widget.groupId, widget.userName, widget.groupName);
              },
              icon: Icon(Icons.more_vert_outlined)),
        ],
        elevation: 0.0,
      ),
      body: Stack(
        alignment: Alignment.topRight,
        children: [Chatwidget(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName,
          ),
          meetingCode !=null ? FlatButton(onPressed: () {
            showWidgitFunc(
                context, meetingCode!, user, widget.groupId, widget.groupName);
          } ,
          padding: EdgeInsets.all(8),
           child: Text('Join Meet'), 
           color: color,
           ) : Container(),
          ]
      ),
    );
  }
}
