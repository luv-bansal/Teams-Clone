import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getUsername(String? email) {
    return "${email!.split('@')[0]}";
  }
}

var appID = 'f95dbb7223ad476590d64beb926af0a2';
var tokenid =
    '006f95dbb7223ad476590d64beb926af0a2IAADSxf1655OSLU3XmPIzUUX1wmWkvU2hRYNJuVqeKQ+2uLcsooAAAAAEAAm+nFWtuHVYAEAAQC54dVg';

String toDateFunc(DateTime dateTime) {
  final date = DateFormat.yMMMEd().format(dateTime);
  return '$date';
}

String toTimeFunc(DateTime dateTime) {
  final date = DateFormat.Hm().format(dateTime);
  return '$date';
}

Color color = Color(0xff37A7FF);
Color blackColor = Color(0xff19191b);
Color onlineDotColor = Color(0xff46dc64);
Color whiteColor = Colors.white;
Color separatorColor = Color(0xff272c35);
Color senderColor = Color(0xff2b343b);
Color receiverColor = Color(0xff1e2225);

final Gradient fabGradient = LinearGradient(
    colors: [Color(0xff00b6f3), Color(0xff0184dc)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);


BoxDecoration buttonDecoration = BoxDecoration(
  gradient:
      LinearGradient(colors: [Color(0xff37A7FF), Colors.lightBlue.shade300]),
  borderRadius: BorderRadius.all(Radius.circular(18)),
);
