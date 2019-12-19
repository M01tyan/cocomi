import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// sad: 0, normal: 1, happy: 2

class Emotion {
  Emotion({
    @required this.date,
    @required this.emotion
  }) : assert(date != null),
       assert(emotion != null);
  final DateTime date;
  final int emotion;
  
  final _weekName = ['', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  String get assetName => emotion == 0 ? 'assets/sad.png' : (emotion == 1 ? 'assets/normal.png' : 'assets/happy.png');
  int get printDate => date.day;
  String get printWeek => _weekName[date.weekday];
  Color get weekColor => date.weekday == 6 ? Colors.lightBlue[600] : (date.weekday == 7 ? Colors.red[500] : Colors.grey[700]);
}