import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class CurrentHeadacheProgressScreen extends StatefulWidget {
  @override
  _CurrentHeadacheProgressScreenState createState() => _CurrentHeadacheProgressScreenState();
}

class _CurrentHeadacheProgressScreenState extends State<CurrentHeadacheProgressScreen>{
  DateTime _dateTime;
  int _totalTime = 0; //in minutes
  Timer _timer;

  String _displayTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = DateTime.now();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if(_totalTime == (24*60)) {
        timer.cancel();
      } else {
        setState(() {
          _totalTime++;
        });
      }
    });

    _displayTime = '0 h 0 m';
  }

  String _getDisplayTime() {
    int hours = _totalTime ~/ 60;
    int minutes = _totalTime % 60;

    return '$hours h $minutes m';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                decoration: BoxDecoration(
                  color: Constant.backgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${Utils.getMonthName(_dateTime.month)} ${_dateTime.day}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostMedium
                            ),
                          ),
                          Image(
                            image: AssetImage(Constant.closeIcon),
                            width: 26,
                            height: 26,
                          ),
                        ],
                      ),
                      Divider(
                        height: 30,
                        thickness: 1,
                        color: Constant.chatBubbleGreen,
                      ),
                      SizedBox(height: 50,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          Constant.yourCurrentHeadache,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Constant.chatBubbleGreen,
                              fontFamily: Constant.jostMedium
                          ),
                        ),
                      ),
                      SizedBox(height: 50,),
                      Container(
                        width: 170,
                        height: 170,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ClipPath(
                                clipper: ProgressClipper(percent: ((_totalTime)/(24 * 60)) * 100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: <Color>[
                                          Color(0xff0E4C47),
                                          Constant.chatBubbleGreen,
                                        ]),
                                  ),
                                ),
                              )
                            ),
                            /*Container(
                              child: GradientProgressBar(
                                painter: GradientProgressBarPainter(),
                              ),
                            ),*/
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Color(0xff0E4C47),
                                        Color(0xff0E232F),
                                      ]),
                                ),
                                child: Center(
                                  child: Text(
                                    _getDisplayTime(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: Constant.jostMedium,
                                      color: Constant.chatBubbleGreen
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          Constant.started,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: Constant.jostMedium,
                            color: Constant.chatBubbleGreen
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Aug 16, 10:34 AM',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: Constant.jostRegular,
                            color: Constant.chatBubbleGreen
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BouncingWidget(
                            onPressed: () {
                              Navigator.pushNamed(context, Constant.addHeadacheOnGoingScreenRouter);
                            },
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.3, color: Constant.chatBubbleGreen),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  Constant.addDetails,
                                  style: TextStyle(
                                      color: Constant.chatBubbleGreen,
                                      fontSize: 15,
                                      fontFamily: Constant.jostMedium),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BouncingWidget(
                            onPressed: () {},
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: Constant.chatBubbleGreen,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  Constant.endHeadache,
                                  style: TextStyle(
                                      color: Constant.bubbleChatTextView,
                                      fontSize: 15,
                                      fontFamily: Constant.jostMedium),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressClipper extends CustomClipper<Path> {
  final double percent;

  const ProgressClipper({this.percent = 0});
  @override
  Path getClip(Size size) {
    // TODO: implement getClip\
    double sectorValue = 25;

    //for if (percent >= 50 && percent <= 62.5)
    if(percent >= 50 && percent < 62.5) {
      return Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
              Rect.fromLTWH(0, 0, size.width, size.height)
          ),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width * 0.5, size.height)
          ..lineTo(size.width * ((62.5 - percent) / sectorValue), size.height)
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    } else if (percent >= 62.5 && percent < 87.5){
      return Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
              Rect.fromLTWH(0, 0, size.width, size.height)
          ),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height * ((87.5 - percent) / sectorValue))
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    } else if (percent >= 87.5 && percent < 100){
      return Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
              Rect.fromLTWH(0, 0, size.width, size.height)
          ),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(size.width * ((percent - 87.5) / sectorValue), 0)
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    } else if (percent >= 0 && percent < 12.5) {
      return Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
              Rect.fromLTWH(0, 0, size.width, size.height)
          ),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, 0)
          ..lineTo(size.width * (0.5 + (percent / sectorValue)), 0)
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    } else if (percent >= 12.5 && percent < 37.5) {
      return Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
              Rect.fromLTWH(0, 0, size.width, size.height)
          ),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, size.height * ((percent - 12.5) / sectorValue))
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    } else if (percent >= 37.5 && percent < 50) {
      return Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
              Rect.fromLTWH(0, 0, size.width, size.height)
          ),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(size.width * (0.5 + ((50 - percent) / sectorValue)), size.height)
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class GradientProgressBar extends SingleChildRenderObjectWidget {
  GradientProgressBar({
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

class GradientProgressBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Constant.chatBubbleGreen;

    print(size.width);

    var circleRect = Offset(85, 0) & Size(170, 170);
    canvas.drawArc(circleRect, -pi/3, pi*3, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
