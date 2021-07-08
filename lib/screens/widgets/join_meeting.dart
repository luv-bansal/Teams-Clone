import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/meeting.dart';
import 'package:teams_clone/services/meeting_methods.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'callingPage.dart';
import 'package:toggle_switch/toggle_switch.dart';

class JoinMeetingWidget extends StatefulWidget {
  JoinMeetingWidget({
    required this.text,
    required this.icon,
    this.height,
  });
  final String text;
  final IconData icon;
  final height;

  @override
  _JoinMeetingWidgetState createState() => _JoinMeetingWidgetState();
}

class _JoinMeetingWidgetState extends State<JoinMeetingWidget> {
  bool _validateError = false;
  TextEditingController _joiningController = TextEditingController();
  late String meetingCode;

  User? currUser = FirebaseAuth.instance.currentUser;

  int mic = 1;
  int videoOn = 1;

  @override
  void initState() {
    super.initState();
    mic = 1;
    videoOn = 1;
    _joiningController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await showWidgitFunc(context);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: widget.height,
          decoration: buttonDecoration,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  widget.icon,
                  size: 40,
                  color: Colors.white,
                ),
                Text(
                  widget.text,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showWidgitFunc(context) async {
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
                height: 2 * height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  color: Color(0xFF141518),
                  shadowColor: Colors.grey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        width: width * 0.6,
                        height: 2 * height / (16),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          color: Color(0xff37A7FF),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Text(
                          'Join a meeting',
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _joiningController,
                          decoration: InputDecoration(
                            errorText: _validateError
                                ? 'Channel name is mandatory'
                                : null,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white60,
                                )),
                            hintText: 'Meeting Code',
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width * 0.6,
                        decoration: buttonDecoration,
                        child: FlatButton(
                          onPressed: () async {
                            print(_joiningController.text);
                            meetingCode = _joiningController.text;
                            setState(() {
                              meetingCode.isEmpty
                                  ? _validateError = true
                                  : _validateError = false;
                            });
                            if (_validateError == false) {
                              Navigator.of(context).pop();
                              await onJoin();
                              _joiningController.text = '';
                            }
                          },
                          child: Text(
                            'Join',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
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
                                setState(() {
                                  mic = index;
                                });
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
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
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
                                setState(() {
                                  videoOn = index;
                                });
                              },
                            ),
                          ],
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

  // To ask the user for access to the camera and microphone, we use a package named permission_handler.
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin() async {
    setState(() {
      _joiningController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    MeetingMethods meetingMethods = MeetingMethods();
    bool isExist = await meetingMethods.isMeetingExist(channelId: meetingCode);

    if (isExist) {
      await meetingMethods.addMember(channelId: meetingCode, member: currUser!);
    } else {
      Meeting meeting = Meeting(people: [], channelId: meetingCode);
      await meetingMethods.makeCall(meeting: meeting);
      await meetingMethods.addMember(channelId: meetingCode, member: currUser!);
    }
    int userid;
    userid = await meetingMethods.fetchUserId(currUser!);
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    if (!_validateError) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              userId: userid,
              channelName: meetingCode,
              mic: mic,
              videoOn: videoOn,
              user: currUser!,
            ),
          ));
    } else {
      return;
    }
  }
}
