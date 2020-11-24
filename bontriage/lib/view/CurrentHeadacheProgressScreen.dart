import 'dart:async';
import 'dart:math';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/blocs/CurrentHeadacheProgressBloc.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class CurrentHeadacheProgressScreen extends StatefulWidget {
  @override
  _CurrentHeadacheProgressScreenState createState() =>
      _CurrentHeadacheProgressScreenState();
}

class _CurrentHeadacheProgressScreenState
    extends State<CurrentHeadacheProgressScreen> {
  DateTime _dateTime;
  DateTime _storedDateTime;
  int _totalTime = 0; //in minutes
  Timer _timer;
  bool isShowDayBorder = false;
  bool _isAlreadyDataFetched = false;
  CurrentHeadacheProgressBloc _currentHeadacheProgressBloc;

  bool _isShowErrorMessage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = DateTime.now().toUtc();

    _currentHeadacheProgressBloc = CurrentHeadacheProgressBloc();

    _currentHeadacheProgressBloc.fetchDataFromLocalDatabase();

    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _totalTime++;

        if ((_totalTime ~/ 60) > 23) isShowDayBorder = true;
      });
    });
  }

  String _getDisplayTime() {
    int hours = _totalTime ~/ 60;
    int minute = _totalTime % 60;

    if (hours < 10) {
      if (minute < 10) {
        return '$hours:0$minute h';
      } else {
        return '$hours:$minute h';
      }
    } else if (hours < 24) {
      if (minute < 10) {
        return '${hours}h 0${minute}m';
      } else {
        return '${hours}h ${minute}m';
      }
    } else {
      int days = (hours == 24) ? 1 : hours ~/ 24;
      hours = hours % 24;
      if (minute < 10) {
        return '$days day,\n$hours:0$minute h';
      } else {
        return '$days day,\n$hours:$minute h';
      }
    }
  }

  double _getCurrentHeadacheProgressPercent() {
    double percentValue = 0;

    percentValue = ((_totalTime % (24 * 60)) / (24 * 60));
    if (percentValue > 1) {
      percentValue -= 1;
    }
    return percentValue * 100;
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch(e) {
      print(e);
    }
    _currentHeadacheProgressBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                decoration: BoxDecoration(
                  color: Constant.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
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
                                fontSize: 16,
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostMedium),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image(
                              image: AssetImage(Constant.closeIcon),
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 30,
                        thickness: 1,
                        color: Constant.chatBubbleGreen,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      StreamBuilder(
                        stream: _currentHeadacheProgressBloc.stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            if(snapshot.data != null && snapshot.data is CurrentUserHeadacheModel && !_isAlreadyDataFetched) {
                              _resetTimeSeconds(snapshot.data);
                            }
                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Constant.yourCurrentHeadache,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Constant.chatBubbleGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  width: 190,
                                  height: 190,
                                  child: Stack(
                                    children: [
                                      Visibility(
                                        visible: isShowDayBorder,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Constant.chatBubbleGreen,
                                                width: 3),
                                          ),
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: ClipPath(
                                            clipper: ProgressClipper(
                                                percent: /*((_totalTime)/(24 * 60)) * 100)*/ _getCurrentHeadacheProgressPercent()),
                                            child: Container(
                                              width: 170,
                                              height: 170,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Constant.chatBubbleGreen
                                              ),
                                            ),
                                          ),
                                      ),
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
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: Constant.jostMedium,
                                                  color: Constant.chatBubbleGreen),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Constant.started,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: Constant.jostMedium,
                                        color: Constant.chatBubbleGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    (_storedDateTime != null) ? '${Utils.getShortMonthName(_storedDateTime.month)} ${_storedDateTime.day}, ${Utils.getTimeInAmPmFormat(_storedDateTime.hour, _storedDateTime.minute)}' : '${Utils.getShortMonthName(DateTime.now().month)} ${DateTime.now().day}, ${Utils.getTimeInAmPmFormat(DateTime.now().hour, DateTime.now().minute)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: Constant.jostRegular,
                                        color: Constant.chatBubbleGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Visibility(
                                  visible: _isShowErrorMessage,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage(Constant.warningPink),
                                        width: 22,
                                        height: 22,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Constant.logHeadacheError,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Constant.pinkTriggerColor,
                                            fontFamily: Constant.jostRegular),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BouncingWidget(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(context,
                                            Constant.addHeadacheOnGoingScreenRouter);
                                      },
                                      child: Container(
                                        width: 130,
                                        padding: EdgeInsets.symmetric(vertical: 7),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.3,
                                              color: Constant.chatBubbleGreen),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Constant.addEditDetails,
                                            style: TextStyle(
                                                color: Constant.chatBubbleGreen,
                                                fontSize: 13,
                                                fontFamily: Constant.jostMedium),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BouncingWidget(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(context,
                                            Constant.addHeadacheOnGoingScreenRouter,
                                            arguments: true);
                                      },
                                      child: Container(
                                        width: 130,
                                        padding: EdgeInsets.symmetric(vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Constant.chatBubbleGreen,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Constant.endHeadache,
                                            style: TextStyle(
                                                color: Constant.bubbleChatTextView,
                                                fontSize: 13,
                                                fontFamily: Constant.jostMedium),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
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

  void _resetTimeSeconds(CurrentUserHeadacheModel currentUserHeadacheModel) {
    try {
      DateTime dateTime = DateTime.parse(currentUserHeadacheModel.selectedDate);
      _storedDateTime = dateTime.toLocal();
      Duration duration = _dateTime.difference(dateTime);

      if(duration.inDays < 3)
        _totalTime = duration.inMinutes + 1;
      else {
        _isShowErrorMessage = true;
        _totalTime = 72 * 60;
        _timer.cancel();
      }
      isShowDayBorder = duration.inDays >= 1;
      _isAlreadyDataFetched = true;
    } catch(e) {
      print(e);
    }
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
    if (percent >= 50 && percent < 62.5) {
      return Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width * 0.5, size.height)
          ..lineTo(size.width * ((62.5 - percent) / sectorValue), size.height)
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    } else if (percent >= 62.5 && percent < 87.5) {
      return Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height * ((87.5 - percent) / sectorValue))
          ..lineTo(size.width * 0.5, size.height * 0.5)
          ..close(),
      );
    } else if (percent >= 87.5 && percent < 100) {
      return Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
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
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
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
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
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
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(
              size.width * (0.5 + ((50 - percent) / sectorValue)), size.height)
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
  void updateRenderObject(
      BuildContext context, RenderCustomPaint renderObject) {
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
    canvas.drawArc(circleRect, -pi / 3, pi * 3, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
