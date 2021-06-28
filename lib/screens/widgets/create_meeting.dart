import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/widgets/scheduleMeet/calendar_widget.dart';
import 'createMeeting/get_meeting_link.dart';
import 'createMeeting/instant_meeting.dart';


class CreateMeeting extends StatefulWidget {
  const CreateMeeting({Key? key}) : super(key: key);

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => onButtonPressed(),
        child: Text(
          "Create Meeting" ,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,

          ),
        ),
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff37A7FF),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),

    );
  }

  void onButtonPressed(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        color: Colors.black,
        child: Container(
            height: 2*(MediaQuery.of(context).size.height)/9,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: builtBottomNavigationMenu(context)
        ),
      );
    });
  }

  Column builtBottomNavigationMenu(BuildContext context) {
    return Column(
      children: [
        GetMeetingLink(),
        InstantMeeting(),
        ListTile(
          leading: Icon(Icons.schedule, color: Colors.white70,),
          title: Text('Schedule Meeting',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarWidget() ));
          },
        )
      ],
    );
  }

}



