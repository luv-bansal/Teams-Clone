import 'package:flutter/material.dart';
import 'package:teams_clone/screens/search_screen.dart';
import 'package:teams_clone/screens/teamsScreen/add_member.dart';
import 'package:teams_clone/services/teams_methods.dart';
import 'package:teams_clone/utils/utilities.dart';

TeamsMethods teamsMethods = TeamsMethods();

addOptionsModal(context, groupId, userName, groupName) {
  showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: blackColor,
      builder: (context) {
        return Container(
          height: (MediaQuery.of(context).size.height) * 0.4,
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
              },
              title: Text('Leave team'),
            )),
            Expanded(
                child: ListTile(
              leading: Icon(Icons.group),
              onTap: () {},
              title: Text('All members'),
            )),
          ]),
        );
      });
}
