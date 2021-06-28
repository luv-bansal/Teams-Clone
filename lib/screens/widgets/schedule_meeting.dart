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
                  size: 40,color: Colors.white,
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

  Future showWidgitFunc(context) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return await showDialog(
        useSafeArea: true,
        context: context,
        builder: (context){
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: width*0.8,
                height: 2*height/4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  color: Color(0xFF141518),
                  shadowColor: Colors.grey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        width: width*0.7,
                        height: 2*height/(16),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          color: Color(0xff37A7FF),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Text(
                          'Join a meeting',
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}