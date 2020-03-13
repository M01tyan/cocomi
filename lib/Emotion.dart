import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// sad: 0, normal: 1, happy: 2

// 感情クラス
class Emotion {
  // 日付と感情を引数
  Emotion({
    @required this.date,
    @required this.emotion
  }) : assert(date != null),
       assert(emotion != null);
  final DateTime date;
  final int emotion;
  
  final _weekList = ['', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final _monthName = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  String get assetName {
    switch(emotion) {
      case 0: return 'assets/sad.png';
      case 1: return 'assets/normal.png';
      case 2: return 'assets/happy.png';
      // default: return 'assets/sad.png';
    }
    return '';
  }

  String get printDay => date.day.toString();
  String get printWeek => _weekList[date.weekday];
  String get printJapaneseMonth => '${date.month}月';
  String get printEnglishMonth => _monthName[date.month-1];
  String get printAmPm => DateFormat("a").format(date);
  String get printTime => DateFormat("HH:mm").format(date).toString();

  Color get weekColor {
    switch (date.weekday) {
      case 6: return Colors.lightBlue[600];
      case 7: return Colors.red[500];
      default: return Colors.grey[700];
    }
  }

  int get emotionColor {
    switch (emotion) {
      case 0: return 0xFF6CB2F8;
      case 1: return 0xFFF8C36D;
      case 2: return 0xFFF8B4EE;
    }
  }

  Emotion.fromJson(Map<String, dynamic> json)
    : emotion = json['emotion'],
      date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() => {
    'emotion': emotion,
    'date': date.toIso8601String(),
  };
}