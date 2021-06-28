import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/event_data_source.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
class ShowDailyMeeting extends StatefulWidget {
  const ShowDailyMeeting({Key? key}) : super(key: key);

  @override
  _ShowDailyMeetingState createState() => _ShowDailyMeetingState();
}

class _ShowDailyMeetingState extends State<ShowDailyMeeting> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;
    if(selectedEvents.isEmpty){
      return Container();
    }else{
      return SfCalendarTheme(
          data: SfCalendarThemeData(
      ),
        child: SfCalendar(
          initialDisplayDate: provider.selectedDate,
          view: CalendarView.timelineDay,
          dataSource: EventDataSource(provider.events),
        ),
      );
    }
  }
}
