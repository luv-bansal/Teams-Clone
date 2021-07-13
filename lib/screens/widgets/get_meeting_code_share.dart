import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:share/share.dart';

  shareMeetingCode(BuildContext context, String meetingCode) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF262626),
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            "Here's your meeting link",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Copy this link and sent it to people that you want to meet with. \n ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(meetingCode),
                    InkWell(
                        onTap: () {
                          final data = ClipboardData(text: meetingCode);
                          Clipboard.setData(data);
                        },
                        child: Icon(Icons.copy)),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF393939),
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            ],
          ),
          actions: [
            GestureDetector(
                onTap: () async {
                  await Share.share("Join meet using given meeting code \n \n" +
                      "Meeting Code: " + meetingCode );
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(left: 35, right: 35, bottom: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Share Invitation",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(8)),
                ))
          ],
        );
      });
}
