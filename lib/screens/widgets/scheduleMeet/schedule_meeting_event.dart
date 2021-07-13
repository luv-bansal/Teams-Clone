import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/event.dart';
import 'package:teams_clone/models/events_info.dart';
import 'package:teams_clone/screens/widgets/scheduleMeet/add_attendee.dart';
import 'package:teams_clone/services/events_methods.dart';
import 'package:teams_clone/utils/calendar_clients.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';

import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:toggle_switch/toggle_switch.dart';

class ScheduleMeetingEvent extends StatefulWidget {
  final Event? event;
  const ScheduleMeetingEvent({Key? key, this.event}) : super(key: key);

  @override
  _ScheduleMeetingEventState createState() => _ScheduleMeetingEventState();
}

class _ScheduleMeetingEventState extends State<ScheduleMeetingEvent> {
  Storage storage = Storage();
  CalendarClient calendarClient = CalendarClient();
  final _formKey = GlobalKey<FormState>();
  late DateTime toDate;
  late DateTime fromDate;
  TextEditingController titleControler = TextEditingController();

  late String currentTitle;
  late String currentDesc;
  late String currentLocation;
  late String currentEmail;
  late String errorString = '';
  // List<String> attendeeEmails = [];
  List<calendar.EventAttendee> attendeeEmails = [];
  bool shouldNofityAttendees = true;
  bool hasConferenceSupport = false;

  @override
  void initState() {
    super.initState();
    titleControler.addListener(() {
      setState(() {});
    });
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 1));
    } else {
      final event = widget.event;
      fromDate = event!.from;
      toDate = event.to;
      titleControler.text = event.title;
    }
  }

  @override
  void dispose() {
    titleControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        leading: CloseButton(),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              await saveForm();
            },
            icon: Icon(Icons.done),
            label: Text('Save'),
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent, primary: Colors.transparent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              builtTitle(),
              SizedBox(
                height: 16,
              ),
              builtDateTimePicker(),
              SizedBox(
                height: 35,
              ),
              isNofityAttendees(),
              SizedBox(
                height: 25,
              ),
              isConferenceSupport(),
              SizedBox(
                height: 45,
              ),
              addAttendees()
            ],
          ),
        ),
      ),
    );
  }

  Widget addAttendees() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[800],
      ),
      child: FlatButton(
        onPressed: () async {
          attendeeEmails = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return AddAttendee(attendeeEmails: attendeeEmails);
          }));
        },
        child: Text('Schedule Meeting with'),
      ),
    );
  }

  Widget isNofityAttendees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'isNofityAttendees',
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
        ToggleSwitch(
          minWidth: 60.0,
          cornerRadius: 20.0,
          activeBgColors: [
            [color],
            [color]
          ],
          activeFgColor: Colors.white,
          initialLabelIndex: shouldNofityAttendees ? 0 : 1,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          totalSwitches: 2,
          labels: ['Yes', 'No'],
          onToggle: (index) {
            // print('switched to: $index');
            setState(() {
              shouldNofityAttendees = index == 0 ? true : false;
            });
          },
        ),
      ],
    );
  }

  Widget isConferenceSupport() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'isConferenceSupport',
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
        ToggleSwitch(
          minWidth: 60.0,
          cornerRadius: 20.0,
          activeBgColors: [
            [color],
            [color]
          ],
          activeFgColor: Colors.white,
          initialLabelIndex: hasConferenceSupport ? 0 : 1,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          totalSwitches: 2,
          labels: ['Yes', 'No'],
          onToggle: (index) {
         
            setState(() {
              hasConferenceSupport = index == 0 ? true : false;
            });
          },
        ),
      ],
    );
  }

  Widget builtTitle() {
    return TextFormField(
      controller: titleControler,
      style: TextStyle(fontSize: 24, color: Colors.white),
      decoration: InputDecoration(
        hintText: "Add Title",
        hintStyle: TextStyle(color: Colors.white54),
        border: UnderlineInputBorder(),
      ),
      validator: (title) {
        if ((title == null || title.isEmpty)) {
          return 'Title cannot be empty';
        } else {
          return null;
        }
      },
    );
  }

  Widget builtDateTimePicker() {
    return Column(
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  Widget buildFrom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From',
          style: TextStyle(
              color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        Row(
          children: [
            Expanded(
              child: builtDropDownField(
                  text: toDateFunc(fromDate),
                  onClick: () async => await pickFromDateTime(pickDate: true)),
              flex: 2,
            ),
            Expanded(
                child: builtDropDownField(
                    text: toTimeFunc(fromDate),
                    onClick: () async =>
                        await pickFromDateTime(pickDate: false))),
          ],
        ),
      ],
    );
  }

  Widget buildTo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'To',
          style: TextStyle(
              color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        Row(
          children: [
            Expanded(
              child: builtDropDownField(
                  text: toDateFunc(toDate),
                  onClick: () async => await pickToDateTime(pickDate: true)),
              flex: 2,
            ),
            Expanded(
                child: builtDropDownField(
                    text: toTimeFunc(toDate),
                    onClick: () async =>
                        await pickToDateTime(pickDate: false))),
          ],
        ),
      ],
    );
  }

  Widget builtDropDownField(
      {required String text, required VoidCallback onClick}) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      trailing: Icon(
        Icons.arrow_drop_down,
        color: Colors.white70,
      ),
      onTap: onClick,
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(pickDate: pickDate, initialDate: fromDate);
    if (date == null) {
      return;
    }
    if (date.isAfter(toDate)) {
      toDate = date;
    }
    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
        pickDate: pickDate,
        initialDate: toDate,
        firstDate: pickDate ? fromDate : null);
    if (date == null) {
      return;
    }

    if (date.isAfter(toDate)) {
      toDate = date;
    }
    setState(() {
      toDate = date;
    });
  }

  Future pickDateTime(
      {required bool pickDate,
      required DateTime initialDate,
      DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) {
        return null;
      }
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDate = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDate == null) {
        return null;
      }

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDate.hour, minutes: timeOfDate.minute);

      return date.add(time);
    }
  }

  Future saveForm() async {

    await calendarClient
        .insert(
            title: titleControler.text,
            description: ' ',
            location: '  ',
            attendeeEmailList: attendeeEmails,
            shouldNotifyAttendees: shouldNofityAttendees,
            hasConferenceSupport: hasConferenceSupport,
            startTime: toDate,
            endTime: fromDate)
        .then((eventData) async {
    
      String eventId = eventData!['id']!;
      String? eventLink = eventData['link'];

      List<String?> emails = [];

      for (int i = 0; i < attendeeEmails.length; i++)
        emails.add(attendeeEmails[i].email);
  
      EventInfo eventInfo = EventInfo(
        id: eventId,
        name: titleControler.text,
        description: '',
        location: '',
        link: eventLink,
        attendeeEmails: emails,
        shouldNotifyAttendees: shouldNofityAttendees,
        hasConfereningSupport: hasConferenceSupport,
        startTimeInEpoch: toDate.millisecondsSinceEpoch,
        endTimeInEpoch: fromDate.millisecondsSinceEpoch,
      );
     

      await storage
          .storeEventData(eventInfo)
          .whenComplete(() => Navigator.of(context).pop())
          .catchError(
            (e) => print(e),
          );
    }).catchError(
      (e) => print(e),
    );

    final isvalid = _formKey.currentState!.validate();
    if (isvalid) {
      final event = Event(
        title: titleControler.text,
        discription: 'discription',
        to: toDate,
        from: fromDate,
      );

      final provider = Provider.of<EventProvider>(context, listen: false);
      setState(() {
        provider.addEvent(event);
      });

      Navigator.of(context).pop();
    }
  }
}
