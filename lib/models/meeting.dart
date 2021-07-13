import 'package:firebase_auth/firebase_auth.dart';

class Meeting {
  late List people;
  late String channelId;

  Meeting({

    required this.people,
    required this.channelId,
  });

  // to map
  Map<String, dynamic> toMap(Meeting call) {
    Map<String, dynamic> callMap = Map();
    callMap["people"] = call.people;
    callMap["channel_id"] = call.channelId;

    return callMap;
  }

  Meeting.fromMap(Map callMap) {
    this.people = callMap["people"];
    this.channelId = callMap["channel_id"];
  }
}
