import 'package:flutter/foundation.dart';

enum Emotion {sad, normal, happy}

class Item {
  const Item({
    @required this.date,
    @required this.emotion
  }) : assert(date != null),
       assert(emotion != null);

  final DateTime date;
  final Emotion emotion;
}