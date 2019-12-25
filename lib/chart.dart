import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'dart:ui' as ui;

import 'emotion.dart';
import 'home.dart';

// 上部のチャートウィジェット
class EmotionChart extends StatelessWidget {
  const EmotionChart({Key key}) : super(key: key);

  static const int NUMBER_OF_DAYS = 31;

  @override 
  Widget build(BuildContext context) {
    final List<Emotion> emotions = Inherited.of(context, listen: true).emotions;
    final DateTime oldest_date = emotions[emotions.length-1].date;
    final DateTime fromDate = DateTime(oldest_date.year, oldest_date.month, oldest_date.day);
    final DateTime toDate = emotions[0].date;
    var chart_emotions = new List<DataPoint<DateTime>>.generate(emotions.length, (int index) {
      return DataPoint<DateTime>(value: emotions[index].emotion.toDouble(), xAxis: emotions[index].date);
    });
    final scroll_width = max(MediaQuery.of(context).size.width, emotions.length.toDouble() * 80);
    return Container(
      // height: 50.0,
      color: Colors.purple[200],
      // width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CustomPaint(
          painter: ChartPainter(emotions: emotions.reversed.toList()),
          size: Size(scroll_width, MediaQuery.of(context).size.height)
        ),
      ),
    );
    // return BezierChart(
    //   fromDate: fromDate,
    //   toDate: toDate,
    //   selectedDate: toDate,
    //   bezierChartScale: BezierChartScale.WEEKLY,
    //   series: [
    //     BezierLine(
    //       data: chart_emotions,
    //     ),
    //   ],
    //   config: BezierChartConfig(
    //     verticalIndicatorStrokeWidth: 3.0,
    //     verticalIndicatorColor: Colors.black26,
    //     showVerticalIndicator: true,
    //     verticalIndicatorFixedPosition: true,
    //     backgroundColor: Colors.deepPurple[300],
    //     footerHeight: 50.0,
    //   ),
    // );
  }
}

class ChartPainter extends CustomPainter {
  const ChartPainter({this.emotions});
  final List<Emotion> emotions;

  static const int NUMBER_OF_HORIZONTAL_LINES = 5;

  static double leftOffsetStart;
  static double topOffsetEnd;
  static double drawingWidth;
  static double drawingHeight;

  @override
  void paint(Canvas canvas, Size size) {
    leftOffsetStart = size.width * 0.01;
    topOffsetEnd = size.height * 0.8;
    drawingWidth = size.width * 0.95;
    drawingHeight = topOffsetEnd;
    Tuple2<int, int> borderLineValues = _getMinAndMaxValues(emotions);
    _drawHorizontalLinesAndLabels(canvas, size, borderLineValues.item1, borderLineValues.item2);
    _drawBottomLabels(canvas, size);
    // _drawLines(canvas, borderLineValues.item1, borderLineValues.item2);
  }

  Tuple2<int, int> _getMinAndMaxValues(List<Emotion> emotions) {
    int maxWeight = 2;
    int minWeight = 0;

    return Tuple2(minWeight, maxWeight);
  }

  void _drawHorizontalLinesAndLabels(Canvas canvas, Size size, int minLineValue, int maxLineValue) {
    final paint = new Paint()
      ..color = Colors.grey[300];
    int lineStep = _calculateHorizontalLineStep(maxLineValue, minLineValue);
    double offsetStep = _calculateHorizontalOffsetStep;
    for (int line = 0; line < NUMBER_OF_HORIZONTAL_LINES; line++) {
      double yOffset = line * offsetStep;
      _drawHorizontalLabel(maxLineValue, line, lineStep, canvas, yOffset);
      _drawHorizontalLine(canvas, yOffset, size, paint);
    }
  }

  int _calculateHorizontalLineStep(int maxLineValue, int minLineValue) {
    return (maxLineValue - minLineValue) ~/ (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  double get _calculateHorizontalOffsetStep {
    return drawingHeight / (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  void _drawHorizontalLine(ui.Canvas canvas, double yOffset, ui.Size size, ui.Paint paint) {
    canvas.drawLine(
      new Offset(leftOffsetStart, 5 + yOffset),
      new Offset(size.width, 5 + yOffset),
      paint,
    );
  }

  void _drawHorizontalLabel(int maxLineValue, int line, int lineStep, ui.Canvas canvas, double yOffset) {
    ui.Paragraph paragraph = _buildParagraphForLeftLabel(maxLineValue, line, lineStep);
    canvas.drawParagraph(paragraph, new Offset(0.0, yOffset));
  }

  void _drawBottomLabels(Canvas canvas, Size size) {
    for (int daysFromStart = 0; daysFromStart < emotions.length; daysFromStart++) {
      ui.Paragraph paragraph = _buildParagraphForBottomLabel(daysFromStart);
      canvas.drawParagraph(
        paragraph,
        new Offset(daysFromStart*80.toDouble(), 10.0 + drawingHeight),
      );
    }
  }

  ui.Paragraph _buildParagraphForBottomLabel(int daysFromStart) {
    ui.ParagraphBuilder builder = new ui.ParagraphBuilder(
        new ui.ParagraphStyle(fontSize: 10.0, textAlign: TextAlign.right))
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(DateFormat('d MMM').format(emotions[daysFromStart].date));
    final ui.Paragraph paragraph = builder.build()
      ..layout(new ui.ParagraphConstraints(width: 50.0));
    return paragraph;
  }

  ui.Paragraph _buildParagraphForLeftLabel(int maxLineValue, int line, int lineStep) {
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontSize: 10.0,
        textAlign: TextAlign.right,
      )
    )
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText((maxLineValue - line * lineStep).toString());
    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: leftOffsetStart - 4));
    return paragraph;
  }

  @override 
  bool shouldRepaint(ChartPainter old) => emotions.length != old.emotions.length;
}