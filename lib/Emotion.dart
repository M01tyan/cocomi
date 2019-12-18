import 'package:flutter/foundation.dart';
// sad: 0, normal: 1, happy: 2

class Emotion {
  const Emotion({
    @required this.date,
    @required this.emotion
  }) : assert(date != null),
       assert(emotion != null);

  final DateTime date;
  final int emotion;
}