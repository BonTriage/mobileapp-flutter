import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/DateTimePicker.dart';

class TimeSection extends StatefulWidget {
  @override
  _TimeSectionState createState() => _TimeSectionState();

  final Function(String, String) addHeadacheDateTimeDetailsData;

  final String currentTag;
  final String updatedDateValue;
  final bool isHeadacheEnded;
  final CurrentUserHeadacheModel currentUserHeadacheModel;

  const TimeSection(
      {Key key,
      this.currentTag,
      this.updatedDateValue,
      this.addHeadacheDateTimeDetailsData,
      this.isHeadacheEnded,
      this.currentUserHeadacheModel})
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
    super.initState();

    //widget.addHeadacheDateTimeDetailsData("ongoing", "Yes");

    widget.addHeadacheDateTimeDetailsData(
        "onset", Utils.getDateTimeInUtcFormat(DateTime.parse(widget.currentUserHeadacheModel.selectedDate)));

    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 350),
      vsync: this,
    );

    _dateTime = DateTime.now();

    if (widget.currentUserHeadacheModel != null) {
      try {
        _selectedStartDate = DateTime.parse(widget.currentUserHeadacheModel.selectedDate);
        _selectedStartDate = DateTime(_selectedStartDate.year, _selectedStartDate.month, _selectedStartDate.day, _selectedStartDate.hour, _selectedStartDate.minute, 0, 0);
        if(!widget.currentUserHeadacheModel.isOnGoing) {
          _selectedEndDate = DateTime.tryParse(widget.currentUserHeadacheModel.selectedEndDate);
          _selectedEndDate = DateTime(_selectedEndDate.year, _selectedEndDate.month, _selectedEndDate.day, _selectedEndDate.hour, _selectedEndDate.minute, 0, 0);
          _selectedEndTime = _selectedEndDate;
          _selectedEndDateAndTime = _selectedEndDate;
        }
        print(_selectedStartDate);
        _selectedStartTime = _selectedStartDate;
      } catch (e) {
        e.toString();
      }
    }

    print(widget.isHeadacheEnded);

    if(widget.isHeadacheEnded != null && widget.isHeadacheEnded) {
      _isEndTimeExpanded = true;
      if(_selectedEndDate == null) {
        /*Duration duration = _selectedStartDate.difference(DateTime.now());
        if(duration.inSeconds.abs() <= (72*60*60)) {
          widget.addHeadacheDateTimeDetailsData(
              "endtime", DateTime.now().toUtc().toIso8601String());
        }
        else {
          DateTime dateTime = DateTime.parse(widget.currentUserHeadacheModel.selectedDate).toLocal();
          dateTime = dateTime.add(Duration(days: 3));
          _selectedEndDate = dateTime;
          _selectedEndTime = dateTime;
          _selectedEndDateAndTime = dateTime;
          widget.addHeadacheDateTimeDetailsData(
              "endtime", dateTime.toUtc().toIso8601String());
        }*/

        _selectedEndDate = DateTime.now();
        _selectedEndTime = _selectedEndDate;
        _selectedEndDateAndTime = _selectedEndDate;
        widget.addHeadacheDateTimeDetailsData(
            "endtime", Utils.getDateTimeInUtcFormat(_selectedEndDateAndTime));
      } else {
        widget.addHeadacheDateTimeDetailsData(
            "endtime", Utils.getDateTimeInUtcFormat(_selectedEndDate));
      }
      Future.delayed(Duration(milliseconds: 500), () {
        widget.addHeadacheDateTimeDetailsData("ongoing", "No");
      });
      _animationController.forward();
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        widget.addHeadacheDateTimeDetailsData("ongoing", "Yes");
      });
    }

    print((_selectedStartDate == null) ? _getDateTime(DateTime.now(), 0) : _getDateTime(_selectedStartDate, 0));
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
              0,
          0);
        }
        widget.addHeadacheDateTimeDetailsData(
            "onset", Utils.getDateTimeInUtcFormat(_selectedStartDate));
      });
    }
  }

  void _onEndDateSelected(DateTime dateTime) {
    //DateTime currentDateTime = DateTime.now();
    print(dateTime);
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, _selectedEndDateAndTime.hour, _selectedEndDateAndTime.minute, 0, 0);
    if (dateTime.isAfter(_selectedStartDate) ||
        dateTime.isAtSameMomentAs(_selectedStartDate)) {
      setState(() {
        if (_selectedEndTime == null) {
          /*Duration duration = _selectedStartDate.difference(dateTime);
          if(duration.inSeconds.abs() <= (72*60*60))
            _selectedEndDate = dateTime;*/
          _selectedEndDate = dateTime;
        } else {
          /*DateTime selectedEndDate = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              _selectedEndTime.hour,
              _selectedEndTime.minute,
              0, 0);

          Duration duration = _selectedStartDate.difference(selectedEndDate);

          if(duration.inSeconds.abs() <= (72*60*60))
            _selectedEndDate = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              _selectedEndTime.hour,
              _selectedEndTime.minute,
              0, 0);*/
          _selectedEndDate = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              _selectedEndTime.hour,
              _selectedEndTime.minute,
              0, 0);
        }

        _selectedEndTime = _selectedEndDate;
        _selectedEndDateAndTime = _selectedEndDate;

        widget.addHeadacheDateTimeDetailsData(
            "endtime", Utils.getDateTimeInUtcFormat(_selectedEndDate));
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        Utils.showValidationErrorDialog(context, 'Invalid End Date.');
      });
    }
    print(dateTime);
  }

  void _onStartTimeSelected(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    dateTime = DateTime(_selectedStartDate.year, _selectedStartDate.month, _selectedStartDate.day, dateTime.hour, dateTime.minute, 0, 0);
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
              0, 0);

        }
        _selectedStartDate = _selectedStartTime;

        if(_selectedEndDateAndTime != null && _selectedEndDateAndTime.isBefore(_selectedStartTime)) {
          _selectedEndDate = _selectedStartTime;
          _selectedEndTime = _selectedEndDate;
          _selectedEndDateAndTime = _selectedEndDate;

          Future.delayed(Duration(milliseconds: 500), () {
            widget.addHeadacheDateTimeDetailsData(
                "endtime", Utils.getDateTimeInUtcFormat(_selectedEndDateAndTime));
          });
        }
        widget.addHeadacheDateTimeDetailsData(
            "onset", Utils.getDateTimeInUtcFormat(_selectedStartTime));
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        Utils.showValidationErrorDialog(context, 'Invalid Start Time.');
      });
    }
    print(dateTime);
  }

  void _onEndTimeSelected(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    dateTime = DateTime(_selectedEndDateAndTime.year, _selectedEndDateAndTime.month, _selectedEndDateAndTime.day, dateTime.hour, dateTime.minute, 0, 0);
    if ((dateTime.isAfter(_selectedStartDate) ||
        dateTime.isAtSameMomentAs(_selectedStartDate)) && (dateTime.isBefore(currentDateTime) || dateTime.isAtSameMomentAs(currentDateTime))) {
      setState(() {
        if (_selectedEndDate == null) {
          /*Duration duration = _selectedStartDate.difference(dateTime);
          if(duration.inSeconds.abs() <= (72*60*60))
            _selectedEndTime = dateTime;*/
          _selectedEndTime = dateTime;
        } else {
          /*DateTime startEndTime = DateTime(
              _selectedEndDate.year,
              _selectedEndDate.month,
              _selectedEndDate.day,
              dateTime.hour,
              dateTime.minute,
              0, 0);

          Duration duration = _selectedStartDate.difference(startEndTime);

          if(duration.inSeconds.abs() <= (72*60*60))
            _selectedEndTime = DateTime(
              _selectedEndDate.year,
              _selectedEndDate.month,
              _selectedEndDate.day,
              dateTime.hour,
              dateTime.minute,
              0, 0);*/
          _selectedEndTime = DateTime(
              _selectedEndDate.year,
              _selectedEndDate.month,
              _selectedEndDate.day,
              dateTime.hour,
              dateTime.minute,
              0, 0);
        }

        _selectedEndDate = _selectedEndTime;
        _selectedEndDateAndTime = _selectedEndTime;
        widget.addHeadacheDateTimeDetailsData(
            "endtime", Utils.getDateTimeInUtcFormat(_selectedEndTime));
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        Utils.showValidationErrorDialog(context, 'Invalid End Time.');
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              Constant.start,
              style: TextStyle(
                  fontSize: 14,
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          /*_openDatePickerBottomSheet(
                              CupertinoDatePickerMode.date, 0);*/
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
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              Constant.end,
              style: TextStyle(
                  fontSize: 14,
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animationController,
          child: FadeTransition(
            opacity: _animationController,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        /*Duration duration = DateTime.now().difference(_selectedStartDate);

                        if(duration.inSeconds.abs() <= (72*60*60)) {
                          _selectedEndDate = DateTime.now();
                          _selectedEndTime = _selectedEndDate;
                        }*/
                        _selectedEndDate = DateTime.now();
                        _selectedEndTime = _selectedEndDate;
                      });

                      _selectedEndDateAndTime = _selectedEndDate;
                      widget.addHeadacheDateTimeDetailsData("endtime", Utils.getDateTimeInUtcFormat(_selectedEndDate));
                    },
                    child: Text(
                      Constant.reset,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                          color: Constant.addCustomNotificationTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: !(widget.currentUserHeadacheModel.isFromRecordScreen ?? false),
          child: Align(
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
                      /*Duration duration = _selectedStartDate.difference(DateTime.now());
                      if(duration.inSeconds.abs() <= (72*60*60)) {
                        _selectedEndDate = DateTime.now();
                        _selectedEndTime = _selectedEndDate;
                        _selectedEndDateAndTime = _selectedEndDate;
                        widget.addHeadacheDateTimeDetailsData(
                            "endtime", DateTime.now().toUtc().toIso8601String());
                      } else {
                        _selectedEndDate = _selectedStartDate.add(Duration(days: 3));
                        _selectedEndTime = _selectedEndDate;
                        _selectedEndDateAndTime = _selectedEndDate;
                        widget.addHeadacheDateTimeDetailsData(
                            "endtime", _selectedEndDateAndTime.toUtc().toIso8601String());
                      }*/
                      _selectedEndDate = DateTime.now();
                      _selectedEndTime = _selectedEndDate;
                      _selectedEndDateAndTime = _selectedEndDate;
                      widget.addHeadacheDateTimeDetailsData(
                          "endtime", Utils.getDateTimeInUtcFormat(DateTime.now()));
                    } else
                      widget.addHeadacheDateTimeDetailsData(
                          "endtime", Utils.getDateTimeInUtcFormat(_selectedEndDateAndTime));
                    widget.currentUserHeadacheModel
                      ..isOnGoing = false
                      ..selectedEndDate = Utils.getDateTimeInUtcFormat(_selectedEndDate);

                    //this condition is put because we don't want to update headache data in db when user comes from record screen
                    /*if(!(widget.currentUserHeadacheModel.isFromRecordScreen ?? false))
                      SignUpOnBoardProviders.db.updateUserCurrentHeadacheData(widget.currentUserHeadacheModel);*/
                  } else {
                    widget.currentUserHeadacheModel.isOnGoing = true;

                    /*if(!(widget.currentUserHeadacheModel.isFromRecordScreen ?? false))
                      SignUpOnBoardProviders.db.updateUserCurrentHeadacheData(widget.currentUserHeadacheModel);*/

                    widget.addHeadacheDateTimeDetailsData("ongoing", "Yes");
                    widget.addHeadacheDateTimeDetailsData("endtime", "");
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
    DateTime dateTime;

    switch(whichPickerClicked) {
      case 1:
        dateTime = _selectedStartTime ?? DateTime.now();
        break;
      case 2:
      case 3:
        dateTime = _selectedEndDateAndTime ?? DateTime.now();
        break;
      default:
        dateTime = DateTime.now();
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) => DateTimePicker(
              cupertinoDatePickerMode: cupertinoDatePickerMode,
              initialDateTime: dateTime,
              onDateTimeSelected:
                  _getDateTimeCallbackFunction(whichPickerClicked),
            ));
  }
}
