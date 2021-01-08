import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/TutorialChatBubble.dart';

class MeScreenTutorial extends StatefulWidget {
  final GlobalKey logDayGlobalKey;
  final GlobalKey addHeadacheGlobalKey;
  final GlobalKey recordsGlobalKey;

  const MeScreenTutorial({Key key, @required this.logDayGlobalKey, @required this.addHeadacheGlobalKey, @required this.recordsGlobalKey}) : super(key: key);

  @override
  _MeScreenTutorialState createState() => _MeScreenTutorialState();
}

class _MeScreenTutorialState extends State<MeScreenTutorial> with SingleTickerProviderStateMixin {

  bool _shouldClip;
  AnimationController _animationController;
  Offset logDayOffset;
  Offset addHeadacheOffset;
  RenderBox logDayRenderBox;
  RenderBox addHeadacheRenderBox;
  RenderBox recordsRenderBox;
  Offset recordsOffset;
  List<List<TextSpan>> _textSpanList;
  List<String> chatBubbleTextList;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _shouldClip = true;
    logDayRenderBox = widget.logDayGlobalKey.currentContext.findRenderObject();
    logDayOffset = logDayRenderBox.localToGlobal(Offset.zero);
    print('LogDayOffset????$logDayOffset???${logDayRenderBox.size}');

    addHeadacheRenderBox = widget.addHeadacheGlobalKey.currentContext.findRenderObject();
    addHeadacheOffset = addHeadacheRenderBox.localToGlobal(Offset.zero);
    print('AddHeadacheOffset????$addHeadacheOffset');

    recordsRenderBox = widget.recordsGlobalKey.currentContext.findRenderObject();
    recordsOffset = recordsRenderBox.localToGlobal(Offset.zero);
    print('RecordsOffset????$recordsOffset');

    /*Future.delayed(Duration(seconds: 10), () {
      setState(() {
        _shouldClip = true;
      });
    });*/

    chatBubbleTextList = [
      'When you’re on the home screen of the app, you’ll be able to log your day by pressing the Log Day button and log your headaches by clicking the Add Headache button.',
      'Last thing before we go — Whenever you want, you can click on Records to track information like how your Compass and Headache Score have evolved over time, the potential impact of changes in medication or lifestyle, and more! This is all based on the suggestions we have made and the steps you and your provider have taken.'
    ];

    _textSpanList = [
      [
        TextSpan(
          text: 'When you’re on the home screen of the app, you’ll be able to log your day by pressing the ',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
        TextSpan(
          text: 'Log Day',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            height: 1.3,
            color: Constant.chatBubbleGreen,
            fontStyle: FontStyle.italic
          ),
        ),
        TextSpan(
          text: ' button and log your headaches by clicking the ',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
        TextSpan(
          text: 'Add Headache',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            height: 1.3,
            color: Constant.chatBubbleGreen,
              fontStyle: FontStyle.italic
          ),
        ),
        TextSpan(
          text: ' button.',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
      [
        TextSpan(
          text: 'Last thing before we go — Whenever you want, you can click on ',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
        TextSpan(
          text: 'Records',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
        TextSpan(
          text: ' to track information like how your Compass and Headache Score have evolved over time, the potential impact of changes in medication or lifestyle, and more! This is all based on the suggestions we have made and the steps you and your provider have taken.',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          ClipPath(
            clipper: TutorialClipper(
              logDayBox: widget.logDayGlobalKey.currentContext.findRenderObject(),
              addHeadacheBox: widget.addHeadacheGlobalKey.currentContext.findRenderObject(),
              currentIndex: _currentIndex,
              shouldClip: _shouldClip
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                color: Constant.backgroundColor.withOpacity(0.9),
                child: Stack(
                  children: [
                    TutorialChatBubble(
                      chatBubbleText: chatBubbleTextList[_currentIndex],
                      textSpanList: _textSpanList[_currentIndex],
                      currentIndex: _currentIndex,
                      nextButtonFunction: () {
                        if(_currentIndex < _textSpanList.length) {
                          setState(() {
                            _currentIndex++;
                            _shouldClip = false;
                          });
                        }
                      },
                      backButtonFunction: () {
                        if(_currentIndex != 0) {
                          setState(() {
                            _currentIndex--;
                            _shouldClip = true;
                          });
                        }
                      },
                    ),
                    Visibility(
                      visible: _shouldClip,
                      child: Padding(
                        padding: EdgeInsets.only(top: logDayOffset.dy + 40, right: logDayOffset.dx - 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image(
                                    image: AssetImage(Constant.tutorialArrowUp),
                                    width: 40,
                                    height: 40,
                                  ),
                                  Image(
                                    image: AssetImage(Constant.tutorialArrowDown),
                                    width: 40,
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_shouldClip,
                      child: Container(
                        padding: EdgeInsets.only(left: recordsOffset.dx - 35, top: recordsOffset.dy - 50),
                        child: Image(
                          image: AssetImage(Constant.tutorialArrowDown2),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialClipper extends CustomClipper<Path> {
  final RenderBox logDayBox;
  final RenderBox addHeadacheBox;
  final RenderBox recordsBox;
  final int currentIndex;
  final bool shouldClip;

  const TutorialClipper({this.logDayBox, this.addHeadacheBox, this.recordsBox, this.currentIndex, this.shouldClip});

  @override
  Path getClip(Size size) {
    if(shouldClip) {
      Offset logDayOffset = logDayBox.localToGlobal(Offset.zero);
      Size logDaySize = logDayBox.size;

      Offset addHeadacheOffset = addHeadacheBox.localToGlobal(Offset.zero);
      Size addHeadacheSize = addHeadacheBox.size;
      return Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(logDayOffset.dx, logDayOffset.dy, logDaySize.width, logDaySize.height), Radius.circular(20)))..addRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(addHeadacheOffset.dx, addHeadacheOffset.dy, addHeadacheSize.width, addHeadacheSize.height), Radius.circular(20)))
          ..close(),
      );
    } else {
      return Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..lineTo(0, 0)
          ..close(),
      );
    }
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
