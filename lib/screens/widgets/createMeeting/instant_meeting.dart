import 'package:flutter/material.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/screens/widgets/callingPage.dart';
import 'package:random_string/random_string.dart';

class InstantMeeting extends StatefulWidget {
  @override
  _InstantMeetingState createState() => _InstantMeetingState();
}

class _InstantMeetingState extends State<InstantMeeting> {
  late final meeting_code;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.video_call_outlined, color: Colors.white70,),
      title: Text('Start a instant meeting',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),),
      onTap: () async {
        Navigator.pop(context);
        meeting_code = randomAlpha(10);
        await onJoin();
      },
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin() async {

    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(channelName: meeting_code),
        ));

  }
}