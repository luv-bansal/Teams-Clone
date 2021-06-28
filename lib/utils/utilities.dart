import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getUsername(String? email) {

    return "live:${email!.split('@')[0]}";

  }
}

var appID = 'f95dbb7223ad476590d64beb926af0a2';
var tokenid = '006f95dbb7223ad476590d64beb926af0a2IAADSxf1655OSLU3XmPIzUUX1wmWkvU2hRYNJuVqeKQ+2uLcsooAAAAAEAAm+nFWtuHVYAEAAQC54dVg';

String toDateFunc(DateTime dateTime){
  final date = DateFormat.yMMMEd().format(dateTime);
  return '$date';
}

String toTimeFunc(DateTime dateTime){
  final date = DateFormat.Hm().format(dateTime);
  return '$date';
}

Color color = Color(0xff37A7FF);

BoxDecoration buttonDecoration = BoxDecoration(
  gradient: LinearGradient(
      colors: [Color(0xff37A7FF),
        Colors.lightBlue.shade300
      ]
  ),
  borderRadius: BorderRadius.all(Radius.circular(18)),

);