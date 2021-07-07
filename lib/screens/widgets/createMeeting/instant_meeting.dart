import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/meeting.dart';
import 'package:teams_clone/services/meeting_methods.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/screens/widgets/callingPage.dart';

class InstantMeeting extends StatefulWidget {
  @override
  _InstantMeetingState createState() => _InstantMeetingState();
}

class _InstantMeetingState extends State<InstantMeeting> {
  late final meeting_code;
  User? currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.video_call_outlined,
        color: Colors.white70,
      ),
      title: Text(
        'Start a instant meeting',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
      ),
      onTap: () async {
        Navigator.pop(context);
        meeting_code = getRandomString(10);
        await onJoin(context, meeting_code);
      },
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin(context, String meeting_code) async {

    Meeting meeting = Meeting(people: [], channelId: meeting_code);

    MeetingMethods meetingMethods = MeetingMethods();
    meetingMethods.makeCall(meeting: meeting);
    meetingMethods.addMember(channelId: meeting_code, member: currUser!);

    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);    
    int userid;
    userid = await meetingMethods.fetchUserId(currUser!); 
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage( userId: userid ,channelName: meeting_code, mic: 1, videoOn: 1,user: currUser!, ),
        ));
  }

}
