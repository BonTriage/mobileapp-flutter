import 'package:flutter/material.dart';
import 'package:mobile/blocs/CalendarHeadacheLogDayDetailsBloc.dart';
import 'package:mobile/models/UserHeadacheLogDayDetailsModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/RecordCalendarHeadacheSection.dart';
import 'package:mobile/view/RecordDayPage.dart';

class CalendarHeadacheLogDayDetailsScreen extends StatefulWidget {
  final DateTime dateTime;

  const CalendarHeadacheLogDayDetailsScreen({Key key, this.dateTime})
      : super(key: key);

  @override
  _CalendarHeadacheLogDayDetailsScreenState createState() =>
      _CalendarHeadacheLogDayDetailsScreenState();
}

class _CalendarHeadacheLogDayDetailsScreenState
    extends State<CalendarHeadacheLogDayDetailsScreen> {
  DateTime _dateTime;
  bool isPageChanged = false;
  CalendarHeadacheLogDayDetailsBloc calendarHeadacheLogDayDetailsBloc;
  UserHeadacheLogDayDetailsModel userHeadacheLogDayDetailsModel =
      UserHeadacheLogDayDetailsModel();

  @override
  void initState() {
    super.initState();
    _dateTime = widget.dateTime;
    calendarHeadacheLogDayDetailsBloc = CalendarHeadacheLogDayDetailsBloc();
    print("SelectedDate??????$_dateTime");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callAPIService();
    });
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
                                  Text(
                                    '${Utils.getMonthName(_dateTime.month)} ${_dateTime.day}',
                                    style: TextStyle(
                                      color: Constant.chatBubbleGreen,
                                      fontSize: 20,
                                      fontFamily: Constant.jostRegular,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image(
                                    image: AssetImage(Constant.closeIcon),
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<dynamic>(
                              stream: calendarHeadacheLogDayDetailsBloc
                                  .calendarLogDayDetailsDataStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  userHeadacheLogDayDetailsModel =
                                      snapshot.data;
                                  return Column(
                                    children: [
                                      RecordCalendarHeadacheSection(
                                          userHeadacheLogDayDetailsModel:
                                              userHeadacheLogDayDetailsModel),
                                      RecordDayPage(
                                          hasData:userHeadacheLogDayDetailsModel.headacheLogDayListData!= null,
                                          dateTime: _dateTime,
                                          userHeadacheLogDayDetailsModel:
                                              userHeadacheLogDayDetailsModel)
                                    ],
                                  );
                                } else {
                                  return Container(
                                    height: 100,
                                  );
                                }
                              })
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

  void callAPIService() {
    Utils.showApiLoaderDialog(context,
        networkStream: calendarHeadacheLogDayDetailsBloc.networkDataStream,
        tapToRetryFunction: () {
      calendarHeadacheLogDayDetailsBloc.enterSomeDummyDataToStream();
    });
    String currentDate = _dateTime.toUtc().toIso8601String();
    List<String> splitString = currentDate.split('.');
    String selectedDate = splitString[0].toString() + 'Z';
    calendarHeadacheLogDayDetailsBloc
        .fetchCalendarHeadacheLogDayData(selectedDate);
  }
}
