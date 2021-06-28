import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/screens/widgets/create_meeting.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'widgets/join_meeting.dart';
import 'widgets/schedule_meeting.dart';
class HomeScreen extends StatelessWidget {



  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black

      ),
      home: Scaffold(
        appBar: AppBar(
          titleSpacing: 10,
          elevation: 5,
          title: Text('   Hi, ${currentUser!.displayName!.split(' ')[0]}  👋',
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
                onPressed: (){
                  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(currentUser!.photoURL ?? 'https://pngtree.com/freepng/avatar-icon-profile-icon-member-login-vector-isolated_5247852.html'),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(22, 25, 22, 16),
              height: 4*height/17,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromRGBO(128, 128, 128, 0.2),
              boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(128, 128, 128, 0.2),
                  )
                ]

              ),

              width: width,
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('New conference',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text('Create conference URL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60
                    ),
                  ),
                  SizedBox(height: 20,),
                  CreateMeeting(),
                ],
              ),

            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: [
                  JoinMeetingWidget(text: 'Join Call', icon: Icons.missed_video_call_rounded, height: 2*height/13,),
                  ScheduleMeetingWidgit(text: 'Schedule meet', icon: Icons.calendar_today, height: 2*height/13,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}




