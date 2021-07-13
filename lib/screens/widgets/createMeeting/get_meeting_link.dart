import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teams_clone/screens/widgets/get_meeting_code_share.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:share/share.dart';

class GetMeetingLink extends StatelessWidget {
  late final meeting_code;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.link, color: Colors.white70,),
      title: Text('Get a meeting link to share',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),),
      onTap: () async {
        Navigator.pop(context);
        meeting_code = getRandomString(10);
        shareMeetingCode(context, meeting_code);
      },
    );
  }

  


}