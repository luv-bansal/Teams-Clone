import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/event.dart';
import 'package:teams_clone/models/event_data_source.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ShowDailyMeeting extends StatefulWidget {
  
  List<Event> events;
  ShowDailyMeeting(this.events);

  @override
  _ShowDailyMeetingState createState() => _ShowDailyMeetingState();
}

class _ShowDailyMeetingState extends State<ShowDailyMeeting> {
  List selectedEvents = [];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    provider.eventsOfSelectedDate.then((value) {
      setState(() {
        selectedEvents = value;
      });
    });

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text('No scheduled Meeting'),
      );
    } else {
      return SfCalendarTheme(
        data: SfCalendarThemeData(),
        child: SfCalendar(
          initialDisplayDate: provider.selectedDate,
          view: CalendarView.timelineDay,
          dataSource: EventDataSource(widget.events),
        ),
      );
    }
  }
}
