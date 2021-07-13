import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';
import 'package:teams_clone/services/teams_methods.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class AddAttendee extends StatefulWidget {
  late List<calendar.EventAttendee> attendeeEmails;

  AddAttendee({required this.attendeeEmails});

  @override
  _AddAttendeeState createState() => _AddAttendeeState();
}

class _AddAttendeeState extends State<AddAttendee> {
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
            onPressed: () => Navigator.pop(context, widget.attendeeEmails),
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
            bool value = true;
            for (int i = 0; i < widget.attendeeEmails.length; i++) {
              if (widget.attendeeEmails[i].email ==
                  suggestionList[index]['email']) {
                value = false;
                break;
              } else {
                value = true;
              }
            }
            print(widget.attendeeEmails);
            if (value) {
              
              
              calendar.EventAttendee eventAttendee = calendar.EventAttendee();

              eventAttendee.email = suggestionList[index]['email'];

              widget.attendeeEmails.add(eventAttendee);
            }
          

            value
                ? ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    backgroundColor: color,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      '${suggestionList[index]['name']} added as attendee',
                      style: TextStyle(color: Colors.white),
                    )))
                : ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: color,
                    content: Text(
                      '${suggestionList[index]['name']}  alraedy added as attendee',
                      style: TextStyle(color: Colors.white),
                    )));
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
