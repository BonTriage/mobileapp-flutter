import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/DateTimePicker.dart';

class TimeSection extends StatefulWidget {
  @override
  _TimeSectionState createState() => _TimeSectionState();

  final Function(String, String) addHeadacheDateTimeDetailsData;

  final String currentTag;
  final String updatedDateValue;

  const TimeSection(
      {Key key,
      this.currentTag,
      this.updatedDateValue,
      this.addHeadacheDateTimeDetailsData})
      : super(key: key);
}

class _TimeSectionState extends State<TimeSection>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime;
  DateTime _selectedStartDate;
  DateTime _selectedEndDate;
  DateTime _selectedStartTime;
  DateTime _selectedEndTime;
  DateTime _selectedEndDateAndTime;
  AnimationController _animationController;
  bool _isEndTimeExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.addHeadacheDateTimeDetailsData(
        "onset", DateTime.now().toUtc().toString());

    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 350),
      vsync: this,
    );

    _dateTime = DateTime.now();

    if (widget.updatedDateValue != null) {
      try {
        _selectedStartDate = DateTime.parse(widget.updatedDateValue).toLocal();
        print(_selectedStartDate);
        _selectedStartTime = _selectedStartDate;
      } catch (e) {
        e.toString();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onStartDateSelected(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    if (currentDateTime.isAfter(dateTime) ||
        currentDateTime.isAtSameMomentAs(dateTime)) {
      setState(() {
        if (_selectedStartTime == null) {
          _selectedStartDate = dateTime;
        } else {
          _selectedStartDate = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              _selectedStartTime.hour,
              _selectedStartTime.minute,
              _selectedStartTime.second);
        }
        widget.addHeadacheDateTimeDetailsData(
            "onset", _selectedStartDate.toUtc().toString());
      });
    }
  }

  void _onEndDateSelected(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    if (currentDateTime.isAfter(dateTime) ||
        currentDateTime.isAtSameMomentAs(dateTime)) {
      setState(() {
        if (_selectedEndTime == null) {
          _selectedEndDate = dateTime;
        } else {
          _selectedEndDate = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              _selectedEndTime.hour,
              _selectedEndTime.minute,
              _selectedEndTime.second);
        }

        _selectedEndDateAndTime = _selectedEndDate;

        widget.addHeadacheDateTimeDetailsData(
            "endtime", _selectedEndDate.toUtc().toString());
      });
    }
    print(dateTime);
  }

  void _onStartTimeSelected(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    if (currentDateTime.isAfter(dateTime) ||
        currentDateTime.isAtSameMomentAs(dateTime)) {
      setState(() {
        if (_selectedStartDate == null) {
          _selectedStartTime = dateTime;
        } else {
          _selectedStartTime = DateTime(
              _selectedStartDate.year,
              _selectedStartDate.month,
              _selectedStartDate.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second);
        }
        widget.addHeadacheDateTimeDetailsData(
            "onset", _selectedStartTime.toUtc().toString());
      });
    }
    print(dateTime);
  }

  void _onEndTimeSelected(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    if (currentDateTime.isAfter(dateTime) ||
        currentDateTime.isAtSameMomentAs(dateTime)) {
      setState(() {
        if (_selectedEndDate == null) {
          _selectedEndTime = dateTime;
        } else {
          _selectedEndTime = DateTime(
              _selectedEndDate.year,
              _selectedEndDate.month,
              _selectedEndDate.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second);
        }
        _selectedEndDateAndTime = _selectedEndTime;
        widget.addHeadacheDateTimeDetailsData(
            "endtime", _selectedEndTime.toUtc().toString());
      });
    }
    print(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Constant.start,
            style: TextStyle(
                fontSize: 14,
                color: Constant.locationServiceGreen,
                fontFamily: Constant.jostRegular),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Constant.backgroundTransparentColor,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _openDatePickerBottomSheet(
                            CupertinoDatePickerMode.date, 0);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          (_selectedStartDate == null)
                              ? _getDateTime(DateTime.now(), 0)
                              : _getDateTime(_selectedStartDate, 0),
                          style: TextStyle(
                              color: Constant.splashColor,
                              fontFamily: Constant.jostRegular,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              Constant.at,
              style: TextStyle(
                  fontSize: 14,
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular),
            ),
            SizedBox(
              width: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Constant.backgroundTransparentColor,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _openDatePickerBottomSheet(
                            CupertinoDatePickerMode.time, 1);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          (_selectedStartTime == null)
                              ? Utils.getTimeInAmPmFormat(
                                  DateTime.now().hour, DateTime.now().minute)
                              : _getDateTime(_selectedStartTime, 1),
                          style: TextStyle(
                              color: Constant.splashColor,
                              fontFamily: Constant.jostRegular,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Constant.end,
            style: TextStyle(
                fontSize: 14,
                color: Constant.locationServiceGreen,
                fontFamily: Constant.jostRegular),
          ),
        ),
        SizeTransition(
          sizeFactor: _animationController,
          child: FadeTransition(
            opacity: _animationController,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Constant.backgroundTransparentColor,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _openDatePickerBottomSheet(
                                  CupertinoDatePickerMode.date, 2);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                (_selectedEndDate == null)
                                    ? '${Utils.getShortMonthName(_dateTime.month)} ${_dateTime.day}, ${_dateTime.year}'
                                    : _getDateTime(_selectedEndDate, 0),
                                style: TextStyle(
                                    color: Constant.splashColor,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Constant.at,
                    style: TextStyle(
                        fontSize: 14,
                        color: Constant.locationServiceGreen,
                        fontFamily: Constant.jostRegular),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Constant.backgroundTransparentColor,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _openDatePickerBottomSheet(
                                  CupertinoDatePickerMode.time, 3);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                (_selectedEndTime == null)
                                    ? Utils.getTimeInAmPmFormat(
                                        _dateTime.hour, _dateTime.minute)
                                    : _getDateTime(_selectedEndTime, 1),
                                style: TextStyle(
                                    color: Constant.splashColor,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Constant.reset,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Constant.jostRegular,
                        fontWeight: FontWeight.w500,
                        color: Constant.addCustomNotificationTextColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isEndTimeExpanded = !_isEndTimeExpanded;

                if (_isEndTimeExpanded) {
                  _dateTime = DateTime.now();
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                if (_isEndTimeExpanded) {
                  widget.addHeadacheDateTimeDetailsData("ongoing", "No");
                  if (_selectedEndDateAndTime == null) {
                    widget.addHeadacheDateTimeDetailsData(
                        "endtime", DateTime.now().toUtc().toString());
                  } else
                    widget.addHeadacheDateTimeDetailsData(
                        "endtime", _selectedEndDateAndTime.toUtc().toString());
                } else {
                  widget.addHeadacheDateTimeDetailsData("ongoing", "Yes");
                  widget.addHeadacheDateTimeDetailsData("endtime", "");
                }
              });
            },
            child: Text(
              (_isEndTimeExpanded)
                  ? Constant.tapHereIfInProgress
                  : Constant.tapHereToEnd,
              style: TextStyle(
                  fontSize: 14,
                  color: Constant.addCustomNotificationTextColor,
                  fontFamily: Constant.jostRegular),
            ),
          ),
        ),
      ],
    );
  }

  Function _getDateTimeCallbackFunction(int whichPickerClicked) {
    switch (whichPickerClicked) {
      case 0:
        return _onStartDateSelected;
      case 1:
        return _onStartTimeSelected;
      case 2:
        return _onEndDateSelected;
      case 3:
        return _onEndTimeSelected;
      default:
        return null;
    }
  }

  ///@param dateTime: DateTime instance
  ///@param type: 0 for date, 1 for time
  String _getDateTime(DateTime dateTime, int type) {
    String dateTimeString = '';
    switch (type) {
      case 0:
        dateTimeString =
            '${Utils.getShortMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
        return dateTimeString;
      case 1:
        dateTimeString =
            Utils.getTimeInAmPmFormat(dateTime.hour, dateTime.minute);
        return dateTimeString;
      default:
        return dateTimeString;
    }
  }

  /// @param cupertinoDatePickerMode: for time and date mode selection
  /// @param whichPickerClicked: 0 for startDate, 1 for startTime, 2 for endDate, 3 for endTime
  void _openDatePickerBottomSheet(
      CupertinoDatePickerMode cupertinoDatePickerMode, int whichPickerClicked) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DateTimePicker(
              cupertinoDatePickerMode: cupertinoDatePickerMode,
              onDateTimeSelected:
                  _getDateTimeCallbackFunction(whichPickerClicked),
            ));
  }
}
