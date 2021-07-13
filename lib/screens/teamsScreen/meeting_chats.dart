import 'package:flutter/material.dart';
import 'package:teams_clone/screens/teamsScreen/widget/chat.dart';

class TeamMeetingChat extends StatefulWidget {
  late final String groupId;
  late final String userName;
  late final String groupName;

  TeamMeetingChat(
      {required this.groupId, required this.userName, required this.groupName});

  @override
  _TeamMeetingChatState createState() => _TeamMeetingChatState();
}

class _TeamMeetingChatState extends State<TeamMeetingChat> {
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
        title: Text("Teams Meeting Chat"),
        
      ),
      body: Chatwidget(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName,),
    );
  }
}
