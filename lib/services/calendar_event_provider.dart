import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/models/event.dart';

class EventProvider extends ChangeNotifier {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  var currUser = FirebaseAuth.instance.currentUser;
  final List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  Future<List<Event>> get eventsOfSelectedDate async => await getEvents();

  void addEvent(Event event) async {
    await firestoreInstance
        .collection("users")
        .doc(currUser!.uid)
        .collection("Scheduled Meetings")
        .add({"Title": event.title, "To": event.to, "From": event.from});

    notifyListeners();
  }

  Future<List<Event>> getEvents() async {
    List<Event> _events = [];
    var meetings = await firestoreInstance
        .collection("users")
        .doc(currUser!.uid)
        .collection("Scheduled Meetings")
        .get();

    meetings.docs.forEach((res) {
      var data = res.data();
      _events.add(Event(
        title: data['Title'],
        to: data['To'].toDate(),
        from: data['From'].toDate(),
        discription: '',
      ));
    });

    return _events;
  }

  void deletePreviosMeetings() async {
    var previousMeetings = await firestoreInstance
        .collection('users')
        .doc(currUser!.uid)
        .collection("Scheduled Meetings")
        .where("From", isLessThan: DateTime.now())
        .get();
    previousMeetings.docs.forEach((res) async {
      await res.reference.delete();
    });
  }
}
