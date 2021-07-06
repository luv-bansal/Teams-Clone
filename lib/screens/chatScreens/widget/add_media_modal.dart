import 'package:flutter/material.dart';
import 'package:teams_clone/utils/utilities.dart';


addMediaModal(context) {
  showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: blackColor,
      builder: (context) {
        return Container(
          height: (MediaQuery.of(context).size.height) * 0.2,
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
                        "Schedule Call",
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
              subtitle: Text('Arrange a call and get reminders'),
              leading: Icon(Icons.schedule),
              onTap: () {},
              title: Text('Schedule Call'),
            ))
          ]),
        );
      });
}
