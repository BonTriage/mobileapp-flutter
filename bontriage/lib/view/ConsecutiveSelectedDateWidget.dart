import 'package:flutter/material.dart';
import 'package:mobile/util/DrawHorizontalLine.dart';
import 'package:mobile/view/DateWidget.dart';

class ConsecutiveSelectedDateWidget extends StatelessWidget {
  final String weekDateData;
  final int calendarType;

  ConsecutiveSelectedDateWidget(this.weekDateData,this.calendarType);

  @override
  Widget build(BuildContext context) {
    return DrawHorizontalLine(
        painter: HorizontalLinePainter(), child: DateWidget(weekDateData,calendarType));
  }
}
