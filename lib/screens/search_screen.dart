import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teams_clone/screens/chatScreens/chat_screen.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/services/google_sign_in.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  late List userList;

  // Search query
  String query = "";

  TextEditingController searchController = TextEditingController();
  var currUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();

    // All list of users
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
                    color: whiteColor,
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

  // Suggestion list based on searching query
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

          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        var uid = suggestionList[index]['uid'];
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatScreen(receiver : suggestionList[index]);
            }));
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
