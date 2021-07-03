import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/event.dart';
import 'package:teams_clone/screens/loading.dart';
import 'package:teams_clone/screens/widgets/create_meeting.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'widgets/join_meeting.dart';
import 'widgets/schedule_meeting.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  List<Event> events = [];
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    Provider.of<EventProvider>(context).deletePreviosMeetings();
    Provider.of<EventProvider>(context).getEvents().then((value) {
      setState(() {
        events = value;
        loading = false;
      });
    });
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loading ? Loading() : Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 5,
        title: Text(
          '   Hi, ${currentUser!.displayName!.split(' ')[0]}  👋',
          style: TextStyle(
            letterSpacing: 0.2,
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            child: FlatButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(currentUser!.photoURL ??
                    'https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg'),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(22, 25, 22, 16),
            height: 4 * height / 17,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(128, 128, 128, 0.2),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(128, 128, 128, 0.2),
                  )
                ]),
            width: width,
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New conference',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Create conference URL',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60),
                ),
                SizedBox(
                  height: 20,
                ),
                CreateMeeting(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                JoinMeetingWidget(
                  text: 'Join Call',
                  icon: Icons.missed_video_call_rounded,
                  height: 2 * height / 13,
                ),
                ScheduleMeetingWidgit(
                  text: 'Schedule meet',
                  icon: Icons.calendar_today,
                  height: 2 * height / 13,
                ),
              ],
            ),
          ),

          events.length > 0
              ? Container(
                  margin: EdgeInsets.only(left: 14, top: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Meetings",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
              : Container(),
          MeetingNotification(events),
          // ListView.builder(itemCount: events.length, itemBuilder: (context, index){
          //   return ListTile(
          //     hoverColor: Colors.grey,
          //     onTap: () {},
          //     title: Text(events[index].title),
          //     trailing: Text('${events[index].to}'),
          //     leading: Icon(Icons.calendar_today, color: Colors.white,),
          //   );
          // })
        ],
      ),
    );
  }
}

class MeetingNotification extends StatelessWidget {
  List events;
  MeetingNotification(this.events);

  @override
  Widget build(BuildContext context) {
    if (events.length == 0) {
      return Container();
    } else if (events.length == 1) {
      return Container(
        height: 50,
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.amber),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            Text(
              events[0].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${events[0].to}',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                Text(events[0].title,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${events[0].to}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                Text(events[1].title),
                Text('${events[1].to}'),
              ],
            ),
          )
        ],
      );
    }
  }
}
