import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/chatScreens/chat_screen.dart';
import 'package:teams_clone/screens/search_screen.dart';
import 'package:teams_clone/screens/teamsScreen/add_member.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:teams_clone/services/meeting_methods.dart';
import 'package:teams_clone/services/teams_methods.dart';
import 'package:teams_clone/utils/utilities.dart';

TeamsMethods teamsMethods = TeamsMethods();
MeetingMethods meetingMethods = MeetingMethods();
GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();
User currUser = FirebaseAuth.instance.currentUser!;

addOptionsModal(context, groupId, userName, groupName) {
  showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: blackColor,
      builder: (context) {
        return Container(
          height: (MediaQuery.of(context).size.height) * 0.35,
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
                        "Manage Team",
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
              leading: Icon(Icons.group_add),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddMemberTeams(groupId: groupId, groupName: groupName);
                }));
              },
              title: Text('Add members'),
            )),
            Expanded(
                child: ListTile(
              leading: Icon(Icons.person_off_outlined),
              onTap: () {
                teamsMethods.teamLeave(groupId, groupName, userName);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    backgroundColor: color,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'you leaved the $groupName',
                      style: TextStyle(color: Colors.white),
                    )));
              },
              title: Text('Leave team'),
            )),
            Expanded(
                child: ListTile(
              leading: Icon(Icons.group),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return teamsMembersList(context, groupId);
                }));
              },
              title: Text('All members'),
            )),
          ]),
        );
      });
}

Widget teamsMembersList(context, String groupId) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Team Members"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Teams")
          .doc(groupId)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.data()!['members'] != null) {
            if (snapshot.data!.data()!['members'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data!.data()!['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data!.data()!['members'].length - index - 1;

                    return FutureBuilder(
                        future: googleSignInProvider.getUserDetailsById(
                            _destructureUid(
                                snapshot.data!.data()!['members'][reqIndex])),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasData) {
                            var userData = snapshot2.data;
                            return ListTile(
                              contentPadding:
                                  EdgeInsets.only(top: 6, bottom: 4),
                              leading: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: color,
                                child: Text(_memberIconText(snapshot.data!
                                    .data()!['members'][reqIndex])),
                              ),
                              trailing: Icon(
                                Icons.more_vert,
                              ),
                              onTap: () {
                                (userData as Map)['uid'] != currUser.uid ? messagePrivately(context, userData) : {};
                              },
                              title: Text(_destructureName(
                                  snapshot.data!.data()!['members'][reqIndex])),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                  });
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}

messagePrivately(context, receiver) {
  showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: blackColor,
      builder: (context) {
        return Container(
          height: (MediaQuery.of(context).size.height) * 0.35,
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
                        "",
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
              leading: Icon(Icons.messenger_sharp),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatScreen(receiver: receiver);
                }));
              },
              title: Text('Message Privately'),
            )),
          ]),
        );
      });
}

String _destructureName(String res) {
  return res.substring(res.indexOf('_') + 1);
}

String _destructureUid(String res) {
  return res.substring(0, res.indexOf('_'));
}

String _memberIconText(String res) {
  res = _destructureName(res);
  return res.split(" ").length == 1
      ? res.split(" ")[0][0]
      : res.split(" ")[0][0] + res.split(" ")[1][0];
}
