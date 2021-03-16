import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class DateTimePicker extends StatefulWidget {
  final CupertinoDatePickerMode cupertinoDatePickerMode;
  final Function(DateTime) onDateTimeSelected;
  final DateTime initialDateTime;
  final bool isFromHomeScreen;

  const DateTimePicker({Key key, @required this.cupertinoDatePickerMode, @required this.onDateTimeSelected, this.initialDateTime, this.isFromHomeScreen = false}) : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime _dateTime;
  DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();

    if(widget.initialDateTime == null) {
      _dateTime = DateTime.now();
    } else {
      _dateTime = widget.initialDateTime;
    }
    _selectedDateTime = _dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  color: Constant.backgroundTransparentColor
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 15),
                      child: GestureDetector(
                        onTap: () {
                          if(!widget.isFromHomeScreen)
                            widget.onDateTimeSelected(_selectedDateTime);
                          Navigator.pop(context, _selectedDateTime);
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: Constant.jostMedium,
                            fontWeight: FontWeight.w500,
                            color: Constant.locationServiceGreen
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(fontSize: 18, color: Constant.locationServiceGreen, fontFamily: Constant.jostRegular),
                        ),
                      ),
                        child: CupertinoDatePicker(
                          initialDateTime: _dateTime,
                          backgroundColor: Colors.transparent,
                          mode: widget.cupertinoDatePickerMode,
                          use24hFormat: false,
                          minimumYear: 2015,
                          maximumDate: (widget.cupertinoDatePickerMode != CupertinoDatePickerMode.time) ? DateTime.now() : null,
                          maximumYear: DateTime.now().year,
                          onDateTimeChanged: (dateTime) {
                            _selectedDateTime = dateTime;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
