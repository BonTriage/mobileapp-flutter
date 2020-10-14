import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/RecordDayPage.dart';

class RecordDayScreen extends StatefulWidget {
  final DateTime dateTime;

  const RecordDayScreen({Key key, this.dateTime}) : super(key: key);

  @override
  _RecordDayScreenState createState() => _RecordDayScreenState();
}

class _RecordDayScreenState extends State<RecordDayScreen> {
  DateTime _dateTime;
  List<Widget> _pageViewWidgetList;
  PageController _pageController;
  int _currentPageIndex;


  bool isPageChanged = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = DateTime.now();
    _currentPageIndex = 1;

    _pageController = PageController(initialPage: _currentPageIndex);

    _pageViewWidgetList = [
      Container(),
      RecordDayPage(
        hasData: true,
      ),
      Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, viewPortConstraints) {
          return Container(
            decoration: Constant.backgroundBoxDecoration,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewPortConstraints.maxHeight,
                ),
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Constant.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(0,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.linear);
                                    },
                                    child: Image(
                                      height: 12,
                                      width: 8,
                                      image: AssetImage(Constant.backArrow),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    '${Utils.getMonthName(_dateTime.month)} ${_dateTime.day}',
                                    style: TextStyle(
                                      color: Constant.chatBubbleGreen,
                                      fontSize: 20,
                                      fontFamily: Constant.jostRegular,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(2,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.linear);
                                    },
                                    child: Image(
                                      height: 12,
                                      width: 8,
                                      image: AssetImage(Constant.nextArrow),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Image(
                                    image: AssetImage(Constant.closeIcon),
                                    width: 26,
                                    height: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Expanded(
                            child: Container(
                              height: 801,
                              child: PageView.builder(
                                itemCount: _pageViewWidgetList.length,
                                controller: _pageController,
                                physics: NeverScrollableScrollPhysics(),
                                onPageChanged: (index) {

                                  if (index == 0 || index == 2) {
                                    setState(() {
                                      if (index > _currentPageIndex) {
                                        _dateTime = DateTime(
                                            _dateTime.year,
                                            _dateTime.month,
                                            _dateTime.day + 1);
                                      } else if (index < _currentPageIndex) {
                                        _dateTime = DateTime(
                                            _dateTime.year,
                                            _dateTime.month,
                                            _dateTime.day - 1);
                                      }
                                    });
                                  }

                                  _currentPageIndex = index;
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    _pageController.jumpToPage(1);
                                  });
                                },
                                itemBuilder: (context, index) {
                                  switch(index) {
                                    case 0:
                                    case 2:
                                      return _pageViewWidgetList[index];
                                    default:
                                      return RecordDayPage(
                                        hasData: true,
                                        dateTime: _dateTime
                                      );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
