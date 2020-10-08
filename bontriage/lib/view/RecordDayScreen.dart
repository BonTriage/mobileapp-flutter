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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = DateTime.now();
    _currentPageIndex = 1;

    _pageController = PageController(initialPage: _currentPageIndex);

    _pageViewWidgetList = [
      RecordDayPage(),
      RecordDayPage(
        hasData: true,
      ),
      RecordDayPage(),
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
                                    onTap: () {},
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
                                    onTap: () {},
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
                                onPageChanged: (index) {
                                  setState(() {
                                    print(index);
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return _pageViewWidgetList[_currentPageIndex];
                                },
                              ),
                              /*Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _getSectionWidget(
                                        Constant.migraineIcon,
                                        'Migrane',
                                        '3:21 hours, Intensity: 4, Disability: 3',
                                        '“Lorem ipsum dolor sit amet, consectetur adipiscing elit”',
                                        '',
                                      ),
                                      _getSectionWidget(
                                          Constant.sleepIcon,
                                          'Sleep',
                                          '7:47 hours, Woke up frequently',
                                          '',
                                          'This is worse than usual'),
                                      _getSectionWidget(
                                          Constant.waterDropIcon,
                                          'Water',
                                          '4 cups',
                                          '',
                                          'This is less than recommended'),
                                      _getSectionWidget(Constant.mealIcon, 'Meals',
                                          'Regular meal times', '', ''),
                                      _getSectionWidget(
                                          Constant.weatherIcon,
                                          'Weather',
                                          '90% humidity',
                                          '',
                                          'This is higher than usual'),
                                      _getSectionWidget(Constant.pillIcon,
                                          'Medication', 'Ibuprofen (200mg)', '', ''),
                                      Text(
                                        'Note:\n“Lorem ipsum dolor sit amet, consectetur adipiscing elit”',
                                        style: TextStyle(
                                            color: Constant.chatBubbleGreen60Alpha,
                                            fontFamily: Constant.jostRegular,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(),
                                      FlatButton.icon(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {},
                                        icon: Image.asset(
                                          Constant.addCircleIcon,
                                          width: 20,
                                          height: 20,
                                        ),
                                        label: Text(
                                          'Add/Edit Info',
                                          style: TextStyle(
                                              color: Constant.chatBubbleGreen,
                                              fontFamily: Constant.jostRegular,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FlatButton.icon(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {},
                                        icon: Image.asset(
                                          Constant.addCircleIcon,
                                          width: 20,
                                          height: 20,
                                        ),
                                        label: Text(
                                          'Add/Edit Headache',
                                          style: TextStyle(
                                              color: Constant.chatBubbleGreen,
                                              fontFamily: Constant.jostRegular,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ],
                                  ),
                                ),*/
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
