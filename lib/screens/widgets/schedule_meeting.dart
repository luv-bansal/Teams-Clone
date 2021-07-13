import 'package:flutter/material.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'scheduleMeet/calendar_widget.dart';

class ScheduleMeetingWidgit extends StatelessWidget {
  ScheduleMeetingWidgit({required this.text, required this.icon, this.height,});
  final String text;
  final IconData icon;
  final height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarWidget() ));
        },
        child: Container(

          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: height,
          decoration: buttonDecoration,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 20,color: Colors.white,
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  
}