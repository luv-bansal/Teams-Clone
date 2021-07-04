import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/meetings/allMembers.dart';
import 'package:teams_clone/screens/meetings/meeting_chat.dart';
import 'package:teams_clone/services/meeting_chat_methods.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallPage extends StatefulWidget {
  final String channelName;
  final int mic;
  final int videoOn;
  final User user;
  const CallPage(
      {required this.channelName,
      required this.mic,
      required this.videoOn,
      required this.user});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  //Add the link to your deployed server here
  String baseUrl = 'https://polar-dawn-99218.herokuapp.com';
  int uid = 0;
  late String token;
  bool videoMute = false;
  bool muted = false;

  bool allRemoteMuted = false;
  bool allRemoteVideoMuted = false;

  static final _users = <int>[];
  final _infoStrings = <String>[];
  static final _usersInfo = [];

  late RtcEngine _engine;

  User? currUser = FirebaseAuth.instance.currentUser;

  MeetingChatMethods meetingChatMethods = MeetingChatMethods();

  @override
  void dispose() {
    meetingChatMethods.deleteChat(widget.channelName);
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    muted = widget.mic == 1 ? false : true;
    videoMute = widget.videoOn == 1 ? false : true;
    // initialize agora sdk
    initialize();
  }

  Future<void> getToken() async {
    final response = await http.get(
      Uri.parse(baseUrl +
              '/rtc/' +
              widget.channelName +
              '/publisher/uid/' +
              uid.toString()
          // To add expiry time uncomment the below given line with the time in seconds
          // + '?expiry=45'
          ),
    );

    print(response.statusCode);
    print(widget.channelName);
    print(baseUrl +
        '/rtc/' +
        widget.channelName +
        '/publisher/uid/' +
        uid.toString());
    if (response.statusCode == 200) {
      print(
          'Token generate: ${baseUrl + '/rtc/' + widget.channelName + '/publisher/uid/' + uid.toString()}');
      setState(() {
        token = response.body;
        token = jsonDecode(token)['rtcToken'];
        print(token);
      });
    } else {
      print('Failed to fetch the token');
    }
  }

  Future<void> initialize() async {
    if (appID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await getToken();
    await _engine.joinChannel(token, widget.channelName, null, 0);
    print('token: $token');
    print('chanel: $widget.channelName');
    print('uid: $uid');
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    videoMute == false ? await _engine.enableVideo() : _engine.disableVideo();
    await _engine.muteLocalAudioStream(muted);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _usersInfo.add(currUser);
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          meetingChatMethods.deleteChat(widget.channelName);
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          _infoStrings.add(info);
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Group Video Calling'),
        actions: [
          IconButton(
              onPressed: () {
                print('jhuj');
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllMembers(
                    channelId: widget.channelName,
                  );
                }));
              },
              icon: Icon(Icons.more))
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(
        child: Stack(
      alignment: Alignment.bottomLeft,
      children: [Container(child: view), Text('${currUser!.displayName}')],
    ));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      case 5:
        return Container(
          child: Column(
            children: [
              _expandedVideoRow(views.sublist(0, 2)),
              _expandedVideoRow(views.sublist(2, 4)),
              _expandedVideoRow(views.sublist(4, 5)),
            ],
          ),
        );
      case 6:
        return Container(
          child: Column(
            children: [
              _expandedVideoRow(views.sublist(0, 2)),
              _expandedVideoRow(views.sublist(2, 4)),
              _expandedVideoRow(views.sublist(4, 6)),
            ],
          ),
        );
      case 7:
        return Container(
          child: Column(
            children: [
              _expandedVideoRow(views.sublist(0, 2)),
              _expandedVideoRow(views.sublist(2, 4)),
              _expandedVideoRow(views.sublist(4, 6)),
              _expandedVideoRow(views.sublist(6, 7)),
            ],
          ),
        );
      case 8:
        return Container(
          child: Column(
            children: [
              _expandedVideoRow(views.sublist(0, 2)),
              _expandedVideoRow(views.sublist(2, 4)),
              _expandedVideoRow(views.sublist(4, 5)),
              _expandedVideoRow(views.sublist(6, 8)),
            ],
          ),
        );
      case 9:
        return Container(
          child: Column(
            children: [
              _expandedVideoRow(views.sublist(0, 2)),
              _expandedVideoRow(views.sublist(2, 4)),
              _expandedVideoRow(views.sublist(4, 7)),
              _expandedVideoRow(views.sublist(7, 9)),
            ],
          ),
        );
      case 10:
        return Container(
          child: Column(
            children: [
              _expandedVideoRow(views.sublist(0, 3)),
              _expandedVideoRow(views.sublist(3, 5)),
              _expandedVideoRow(views.sublist(5, 8)),
              _expandedVideoRow(views.sublist(8, 10)),
            ],
          ),
        );
      default:
    }
    return Container();
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : color,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? color : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onToggleVideoMute,
            child: Icon(
              videoMute ? Icons.videocam_off : Icons.video_call_rounded,
              color: videoMute ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: videoMute ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: color,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => addMediaModal(context),
            child: Icon(
              Icons.more,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.black26,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onToggleVideoMute() {
    setState(() {
      videoMute = !videoMute;
    });
     _engine.enableLocalVideo(!videoMute);
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _muteAllRemoteAudio() {
    setState(() {
      allRemoteMuted = !allRemoteMuted;
    });
    _engine.muteAllRemoteAudioStreams(allRemoteMuted);
  }

  void _muteAllRemoteVideoAudio() {
    setState(() {
      allRemoteVideoMuted = !allRemoteVideoMuted;
    });
    _engine.muteAllRemoteVideoStreams(allRemoteVideoMuted);
  }

  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: blackColor,
        builder: (context) {
          return Container(
            // height: (MediaQuery.of(context).size.height) * 0.2,
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
                          "Manage Meeting",
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
                subtitle: Text('Meeting chat'),
                leading: Icon(Icons.schedule),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MeetingChat(
                      channelId: widget.channelName,
                      user: widget.user,
                    );
                  }));
                },
                title: Text('Chat with anyone in the meeting'),
              )),
              Expanded(
                  child: ListTile(
                subtitle: Text('Meetings Members audio'),
                leading: allRemoteMuted ? Icon(Icons.mic_off) : Icon(Icons.mic),
                onTap: () {
                  _muteAllRemoteAudio();
                },
                title: Text('receive/stop receiving all other audio streams'),
              )),
              Expanded(
                  child: ListTile(
                subtitle: Text('Meeting Members video'),
                leading: allRemoteMuted
                    ? Icon(Icons.video_camera_back)
                    : Icon(Icons.videocam_off),
                onTap: () {
                  _muteAllRemoteVideoAudio();
                },
                title: Text('receive/stop receiving all other video streams'),
              )),
            ]),
          );
        });
  }
}
