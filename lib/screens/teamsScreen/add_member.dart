import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teams_clone/screens/chatScreens/chat_screen.dart';
import 'package:teams_clone/services/meeting_chat_methods.dart';
import 'package:teams_clone/services/teams_methods.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/services/google_sign_in.dart';

class AddMemberTeams extends StatefulWidget {
  late final String groupId;
  late final String groupName;

  AddMemberTeams(
      {required this.groupId, required this.groupName});

  @override
  _AddMemberTeamsState createState() => _AddMemberTeamsState();
}

class _AddMemberTeamsState extends State<AddMemberTeams> {
  late List userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  var currUser = FirebaseAuth.instance.currentUser;

  TeamsMethods teamsMethods = TeamsMethods();

  @override
  void initState() {
    super.initState();
    GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();

    googleSignInProvider.fetchAllUsers(currUser!).then((list) {
      setState(() {
        userList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
          backgroundColor: color,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + 10),
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  controller: searchController,
                  onChanged: (val) {
                    setState(() {
                      query = val;
                    });
                  },
                  cursorColor: blackColor,
                  autofocus: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 35,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => searchController.clear());
                      },
                    ),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Color(0x88ffffff),
                    ),
                  ),
                ),
              ))),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: buildSuggestions(query),
      ),
    );
  }

  //doubt
  buildSuggestions(String query) {
    final List suggestionList = query.isEmpty
        ? []
        : userList.where((user) {
            String _getUsername = user['username'].toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user['name'].toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);

            // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
            //     (user.name.toLowerCase().contains(query.toLowerCase()))),
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        var uid = suggestionList[index]['uid'];
        return ListTile(
          onTap: () {
            teamsMethods.teamJoin(
                widget.groupId, widget.groupName, suggestionList[index]['name'], uid).then((value) {

                  value ? ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  backgroundColor: color,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    '${suggestionList[index]['name']}  joined in the ${widget.groupName}',
                    style: TextStyle(color: Colors.white),
                  ))) :         ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    behavior: SnackBarBehavior.floating,
                      backgroundColor: color,
                      content: Text(
                        '${suggestionList[index]['name']}  alraedy in the Team ${widget.groupName}',
                        style: TextStyle(color: Colors.white),
                      )));
                });

          },
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage(suggestionList[index]['profilePhotoURL']),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            suggestionList[index]['username'],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            suggestionList[index]['name'],
            style: TextStyle(color: Colors.grey),
          ),
        );
      }),
    );
  }
}
