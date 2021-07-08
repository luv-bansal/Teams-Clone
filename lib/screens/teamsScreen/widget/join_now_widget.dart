import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/models/meeting.dart';
import 'package:teams_clone/screens/widgets/callingPage.dart';
import 'package:teams_clone/services/meeting_methods.dart';
import 'package:teams_clone/services/teams_methods.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MicVideoSetting {
  int mic = 1;
  int videoOn = 1;
  MicVideoSetting({required this.mic, required this.videoOn});
}

TeamsMethods teamsMethods = TeamsMethods();

Future showWidgitFunc(
    context, String meetingCode, User currUser, groupId, groupName) async {
  var settings = new MicVideoSetting(mic: 1, videoOn: 1);
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: width * 0.8,
              height: 2 * height / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                color: separatorColor,
                shadowColor: Colors.grey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      width: width * 0.5,
                      height: height / (10),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        color: Color(0xff37A7FF),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        'Create a meeting',
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                   
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mic',
                            style: TextStyle(
                                color: whiteColor, fontWeight: FontWeight.bold),
                          ),
                          ToggleSwitch(
                            minWidth: 60.0,
                            cornerRadius: 20.0,
                            activeBgColors: [
                              [color],
                              [color]
                            ],
                            activeFgColor: Colors.white,
                            initialLabelIndex: 1,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            labels: ['', ''],
                            icons: [Icons.mic_off, Icons.mic],
                            onToggle: (index) {
                              // print('switched to: $index');
                              settings.mic = index;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Video Cam',
                            style: TextStyle(
                                color: whiteColor, fontWeight: FontWeight.bold),
                          ),
                          ToggleSwitch(
                            minWidth: 60.0,
                            cornerRadius: 20.0,
                            initialLabelIndex: 1,
                            activeBgColors: [
                              [color],
                              [color]
                            ],
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            labels: ['', ''],
                            icons: [Icons.videocam_off, Icons.videocam],
                            onToggle: (index) {
                              // print('switched to: $index');

                              settings.videoOn = index;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                     Container(
                      width: width * 0.5,
                      decoration: buttonDecoration,
                      child: FlatButton(
                        onPressed: () async {
                          // Navigator.of(context).pop();

                          teamsMethods.updateMeetingCode(groupId, meetingCode);

                          onJoin(context, meetingCode, settings.mic,
                              settings.videoOn, currUser, groupId, groupName);
                        },
                        child: Text(
                          'Join',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
      
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

Future<void> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
  print(status);
}

Future<void> onJoin(context, String meetingCode, int mic, int videoOn,
    User currUser, String groupId, String groupName) async {
    MeetingMethods meetingMethods = MeetingMethods();
  bool isExist = await meetingMethods.isMeetingExist(channelId: meetingCode);

  if (isExist) {
    await meetingMethods.addMember(channelId: meetingCode, member: currUser);
  } else {
    Meeting meeting = Meeting(people: [], channelId: meetingCode);
    await meetingMethods.makeCall(meeting: meeting);
    await meetingMethods.addMember(channelId: meetingCode, member: currUser);
  }

  await _handleCameraAndMic(Permission.camera);
  await _handleCameraAndMic(Permission.microphone);
  int userid;
  userid = await meetingMethods.fetchUserId(currUser);
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          userId: userid,
          channelName: meetingCode,
          mic: mic,
          videoOn: videoOn,
          user: currUser,
          groupId: groupId,
          groupName: groupName,
        ),
      ));
}
