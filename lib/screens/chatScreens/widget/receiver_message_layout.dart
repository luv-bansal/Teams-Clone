import 'package:flutter/material.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/utils/utilities.dart';


  Widget receiverLayout(Message message, context) {
  Radius messageRadius = Radius.circular(10);

  return Container(
    margin: EdgeInsets.only(top: 12),
    constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
    decoration: BoxDecoration(
      color: receiverColor,
      borderRadius: BorderRadius.only(
        bottomRight: messageRadius,
        topRight: messageRadius,
        bottomLeft: messageRadius,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        message.message!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}
