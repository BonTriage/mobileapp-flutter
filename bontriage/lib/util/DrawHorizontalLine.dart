import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/util/constant.dart';

class DrawHorizontalLine extends SingleChildRenderObjectWidget {
  DrawHorizontalLine({
    Key key,
    this.painter,
    Widget child,
  }) : super(key: key, child: child);

  final CustomPainter painter;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomPaint(
      painter: painter,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderCustomPaint renderObject) {
    renderObject..painter = painter;
  }
}

class HorizontalLinePainter extends CustomPainter {
  bool isHalf;

  HorizontalLinePainter({this.isHalf = false});

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Constant.chatBubbleGreen
      ..strokeWidth = 2.8;

    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width + size.width/2, size.height/2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
// TODO: implement shouldRepaint
    return false;
  }
}