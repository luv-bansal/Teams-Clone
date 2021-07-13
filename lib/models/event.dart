import 'package:flutter/material.dart';

class Event{
  final String title;
  final String discription;
  final DateTime to;
  final DateTime from;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.title,
    required this.discription,
    this.backgroundColor = Colors.lightGreen,
    required this.to,
    required this.from,
    this.isAllDay = false
});

}
