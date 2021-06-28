import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:teams_clone/models/event_data_source.dart';
import 'package:teams_clone/screens/widgets/scheduleMeet/show_daily_meeting.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'schedule_meeting_event.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
        appBar: AppBar(backgroundColor: color, title: Text('Schedule Meeting'), centerTitle: true,),
        body: Center(
            child: SfCalendarTheme(
                data: SfCalendarThemeData(
                    brightness: Brightness.dark,
                    backgroundColor: Colors.black,
                    todayHighlightColor: color,
                ),
                child: SafeArea(child: SfCalendar(
                  dataSource: EventDataSource(events),
                  showNavigationArrow: true,
                  view: CalendarView.month,
                  initialDisplayDate: DateTime.now(),
                  onLongPress: (details){
                    final provider = Provider.of<EventProvider>(context, listen: false);
                    provider.setDate(details.date!);
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ShowDailyMeeting()
                    );
                  },
                ))
            )
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScheduleMeetingEvent()));
        },
        child: Icon(Icons.add),
      ),

    );
  }
}

