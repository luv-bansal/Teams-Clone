import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/event.dart';
import 'package:teams_clone/screens/loading.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';

class ScheduledMeetings extends StatefulWidget {
  const ScheduledMeetings({Key? key}) : super(key: key);

  @override
  _ScheduledMeetingsState createState() => _ScheduledMeetingsState();
}

class _ScheduledMeetingsState extends State<ScheduledMeetings> {
  List<Event> events = [];

  // show loading screen
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    Provider.of<EventProvider>(context).deletePreviosMeetings();

    // All scheduled events of user
    Provider.of<EventProvider>(context).getEvents().then((value) {
      setState(() {
        events = value;

        loading = false;
      });
    });
    return !loading
        ? Scaffold(
            appBar: AppBar(
              title: Text('Scheduled Meetings'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
              ],
            ),
            body: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(events[index].title),
                    trailing: Text('${events[index].to}'),
                  );
                }),
          )
        : Loading();
  }
}
