import 'package:flutter/material.dart';
import 'package:mobile/util/DrawHorizontalLine.dart';
import 'package:mobile/view/DateWidget.dart';

class ConsecutiveSelectedDateWidget extends StatelessWidget {
  final String weekDateData;

  ConsecutiveSelectedDateWidget(this.weekDateData);

  @override
  Widget build(BuildContext context) {
    return DrawHorizontalLine(
        painter: HorizontalLinePainter(), child: DateWidget(weekDateData));
  }
}
