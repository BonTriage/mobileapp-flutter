import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/on_board_chat_bubble.dart';

double logDayHeight = 0;
double logDayWidth = 0;
double addAHeadacheHeight = 0;
double addAHeadacheWidth = 0;
double logDayX = 0;
double logDayY = 0;
double addAHeadacheX = 0;
double addAHeadacheY = 0;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentIndex = 0;
  DateTime _dateTime;
  int _currentTutorialIndex = 0;
  List<TextSpan> textSpanList;
  GlobalKey _keyLogDay = GlobalKey();
  GlobalKey _keyAddAHeadache = GlobalKey();

  void _afterLayout(_) {
    final RenderBox renderBoxRed = _keyLogDay.currentContext.findRenderObject();
    final logDaySize = renderBoxRed.size;
    print(logDaySize.height);

    logDayHeight = logDaySize.height;
    logDayWidth = logDaySize.width;

    final RenderBox renderBox = _keyLogDay.currentContext.findRenderObject();
    final logDayPosition = renderBox.localToGlobal(Offset.zero);
    print(logDayPosition);

    logDayX = logDayPosition.dx;
    logDayY = logDayPosition.dy;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _dateTime = DateTime.now();

    textSpanList = [
      TextSpan(
        text: 'When you’re on the home screen of the app, you’ll be able to log your day by pressing the ',
        style: TextStyle(
          fontSize: 16,
          fontFamily: Constant.jostRegular,
          height: 1.3,
          color: Constant.chatBubbleGreen
        ),
      ),
      TextSpan(
        text: 'Log Day',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            height: 1.3,
            color: Constant.chatBubbleGreen,
        ),
      ),
      TextSpan(
        text: ' button and log your headaches by clicking the ',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen
        ),
      ),
      TextSpan(
        text: 'Add Headache',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            height: 1.3,
            color: Constant.chatBubbleGreen
        ),
      ),
      TextSpan(
        text: ' button.',
        style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen
        ),
      ),
    ];
  }

  /*List<TableRow> _getThisWeekCalender() {
    int day = _dateTime.day;
    int weekDay = _dateTime.weekday;

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xCC0E232F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'THIS WEEK:',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Constant.chatBubbleGreen,
                                    fontFamily: Constant.jostMedium),
                              ),
                              Text(
                                'SEE MORE >',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Constant.chatBubbleGreen,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Center(
                                    child: Text(
                                      'Su',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Constant.locationServiceGreen,
                                          fontFamily: Constant.jostMedium),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'M',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Tu',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'W',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Th',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'F',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Sa',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Center(
                                  child: Text(
                                    '19',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '20',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '21',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '22',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '23',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '24',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '25',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: <Color>[
                                Color(0xff0E4C47),
                                Color(0x910E4C47),
                              ]),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Constant.chatBubbleGreen,
                            width: 2,
                          )),
                      child: Column(
                        children: [
                          Text(
                            'Good morning!\nWhat’s been\ngoing on today?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: Constant.jostMedium,
                                color: Constant.chatBubbleGreen),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BouncingWidget(
                                onPressed: () {},
                                child: Container(
                                  key: _keyLogDay,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Constant.chatBubbleGreen,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Log Day',
                                      style: TextStyle(
                                          color: Constant.bubbleChatTextView,
                                          fontSize: 14,
                                          fontFamily: Constant.jostMedium),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {
                            Navigator.pushNamed(context, Constant.headacheStartedScreenRouter);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Constant.chatBubbleGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Add a Headache',
                                style: TextStyle(
                                    color: Constant.bubbleChatTextView,
                                    fontSize: 14,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            /*ClipPath(
              clipper: ButtonClipper(),
              child: Container(
                color: Color(0xCC0E232F),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: OnBoardChatBubble(
                          chatBubbleText: 'When you’re on the home screen of the app, you’ll be able to log your day by pressing the Log Day button and log your headaches by clicking the Add Headache button.',
                          isShowCrossButton: false,
                          isSpannable: true,
                          textSpanList: textSpanList,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Constant.backgroundColor,
        currentIndex: currentIndex,
        selectedItemColor: Constant.chatBubbleGreen,
        unselectedItemColor: Constant.unselectedTextColor,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/me_unselected.png',
              height: 25,
            ),
            activeIcon: Image.asset(
              'images/me_selected.png',
              height: 25,
            ),
            title: Text(
              'ME',
              style: TextStyle(
                fontSize: 12,
                fontFamily: Constant.jostMedium,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/records_unselected.png',
              height: 25,
            ),
            activeIcon: Image.asset(
              'images/records_selected.png',
              height: 25,
            ),
            title: Text(
              'RECORDS',
              style: TextStyle(
                fontSize: 12,
                fontFamily: Constant.jostMedium,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/discover_unselected.png',
              height: 25,
            ),
            activeIcon: Image.asset(
              'images/discover_unselected.png',
              height: 25,
            ),
            title: Text(
              'DISCOVER',
              style: TextStyle(
                fontSize: 12,
                fontFamily: Constant.jostMedium,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/more_unselected.png',
              height: 25,
              width: 30,
            ),
            activeIcon: Image.asset(
              'images/more_unselected.png',
              height: 25,
              width: 30,
            ),
            title: Text(
              'MORE',
              style: TextStyle(
                fontSize: 12,
                fontFamily: Constant.jostMedium,
              ),
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class ButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    print(logDayX);
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(
          Rect.fromLTWH(0, 0, size.width, size.height)
      ),
      Path()
        ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(logDayX, logDayY, logDayWidth, logDayHeight), Radius.circular(20)))
        ..close(),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}
