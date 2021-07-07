import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/teamsScreen/widget/group_tile.dart';
import 'package:teams_clone/screens/teamsScreen/widget/quiet_box.dart';
import 'package:teams_clone/services/meeting_chat_methods.dart';
import 'package:teams_clone/services/teams_methods.dart';
import 'package:teams_clone/utils/utilities.dart';

class Teamsscreen extends StatefulWidget {
  const Teamsscreen({Key? key}) : super(key: key);

  @override
  _TeamsscreenState createState() => _TeamsscreenState();
}

class _TeamsscreenState extends State<Teamsscreen> {
  late User _user;
  late String _groupName;

  TeamsMethods teamsMethods = TeamsMethods();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }



  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));

    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
 
    return res.substring(res.indexOf('_') + 1);
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(_user.uid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.data()!['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if (snapshot.data!.data()!['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data!.data()!['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data!.data()!['groups'].length - index - 1;
                    return GroupTile(
                        userName: snapshot.data!.data()!['name'],
                        groupId: _destructureId(
                            snapshot.data!.data()!['groups'][reqIndex]),
                        groupName: _destructureName(
                            snapshot.data!.data()!['groups'][reqIndex]));
                  });
            } else {
              return QuietBox();
            }
          } else {
            return QuietBox();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          teamsMethods.createGroup(_user.displayName!, _groupName);
          Navigator.of(context).pop();
          
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(fontSize: 15.0, height: 2.0, color: whiteColor)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.group_outlined),
        title: Text('Teams'),
        elevation: 0.0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
        ],
      ),
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
      ),
    );
  }
}
