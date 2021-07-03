import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teams_clone/screens/loading.dart';

class AllMembers extends StatefulWidget {
  final String channelId;
  AllMembers({required this.channelId});

  @override
  _AllMembersState createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
  bool loading = true;
  Widget temp = Container();
  
  @override
  Widget build(BuildContext context) {
    allMembers(widget.channelId).then((value) {
      setState(() {
        print('done');
        loading = false;
        temp = value;
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Members"),
      ),
      body: loading ? Loading() : temp,
    );
  }

  Future<Widget> allMembers(channelId) async {
    var x = await FirebaseFirestore.instance
        .collection('meetings')
        .doc(channelId)
        .get();
    return ListView.builder(
        itemCount: (x.data() as Map<String, dynamic>)['people'].length,
        itemBuilder: (context, index) {
          var member =
              (x.data() as Map<String, dynamic>)['people'][index] as Map;
          print(member);
          return ListTile(
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage( member['profile_photo']),
            ),
            title: Text(member['name']),
          );
        });
  }
}
