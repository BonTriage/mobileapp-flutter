import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/TutorialChatBubble.dart';

class MeScreenTutorialDialog extends StatefulWidget {
  final GlobalKey logDayGlobalKey;
  final GlobalKey addHeadacheGlobalKey;
  final GlobalKey recordsGlobalKey;
  final bool isFromOnBoard;

  const MeScreenTutorialDialog({Key key, @required this.logDayGlobalKey, @required this.addHeadacheGlobalKey, @required this.recordsGlobalKey, this.isFromOnBoard = false}) : super(key: key);

  @override
  _MeScreenTutorialDialogState createState() => _MeScreenTutorialDialogState();
}

class _MeScreenTutorialDialogState extends State<MeScreenTutorialDialog> with SingleTickerProviderStateMixin {

  bool _shouldClip;
  Offset _logDayOffset;
  RenderBox _logDayRenderBox;
  RenderBox _addHeadacheRenderBox;
  RenderBox _recordsRenderBox;
  Offset _recordsOffset;
  List<List<TextSpan>> _textSpanList;
  List<String> _chatBubbleTextList;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _shouldClip = true;
    _logDayRenderBox = widget.logDayGlobalKey.currentContext.findRenderObject();
    _logDayOffset = _logDayRenderBox.localToGlobal(Offset.zero);

    _addHeadacheRenderBox = widget.addHeadacheGlobalKey.currentContext.findRenderObject();

    _recordsRenderBox = widget.recordsGlobalKey.currentContext.findRenderObject();
    _recordsOffset = _recordsRenderBox.localToGlobal(Offset.zero);

    _chatBubbleTextList = [
      Constant.meScreenTutorial1,
      Constant.meScreenTutorial2,
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
              fontStyle: FontStyle.italic
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        if(_currentIndex != 0) {
          setState(() {
            _currentIndex--;
            _shouldClip = true;
          });
        }
        return false;
      },
      child: MediaQuery(
        data: mediaQueryData.copyWith(
          textScaleFactor: mediaQueryData.textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
        ),
        child: Stack(
          children: [
            ClipPath(
              clipper: TutorialClipper(
                logDayBox: _logDayRenderBox,
                addHeadacheBox: _addHeadacheRenderBox,
                recordsBox: _recordsRenderBox,
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
                        chatBubbleText: _chatBubbleTextList[_currentIndex],
                        textSpanList: _textSpanList[_currentIndex],
                        currentIndex: _currentIndex,
                        nextButtonFunction: () {
                          if(_currentIndex < _textSpanList.length - 1) {
                            setState(() {
                              _currentIndex++;
                              _shouldClip = false;
                            });
                          } else {
                            _popOrNavigateToOtherScreen();
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
                          padding: EdgeInsets.only(top: _logDayOffset.dy + 40, right: (!kIsWeb) ? _logDayOffset.dx - 20 : 50),
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
                          padding: EdgeInsets.only(left: _recordsOffset.dx - 35, top: _recordsOffset.dy - 50),
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
      ),
    );
  }

  void _popOrNavigateToOtherScreen() async {
    Navigator.pop(context);

    if(widget.isFromOnBoard ?? false)
      Navigator.pushNamed(context, Constant.profileCompleteScreenRouter);
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
    Offset logDayOffset = logDayBox.localToGlobal(Offset.zero);
    Size logDaySize = logDayBox.size;

    Offset addHeadacheOffset = addHeadacheBox.localToGlobal(Offset.zero);
    Size addHeadacheSize = addHeadacheBox.size;

    if(shouldClip) {
      return Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(logDayOffset.dx, logDayOffset.dy, logDaySize.width, logDaySize.height), Radius.circular(20)))..addRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(addHeadacheOffset.dx, addHeadacheOffset.dy, addHeadacheSize.width, addHeadacheSize.height), Radius.circular(20)))
          ..close(),
      );
    } else {
      Offset recordsOffset = recordsBox.localToGlobal(Offset.zero);
      return Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addOval(Rect.fromLTWH(recordsOffset.dx - 18, recordsOffset.dy - 10, 65, 65))
          ..close(),
      );
    }
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
