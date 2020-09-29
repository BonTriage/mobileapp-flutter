import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class TimeSection extends StatefulWidget {
  @override
  _TimeSectionState createState() => _TimeSectionState();
}

class _TimeSectionState extends State<TimeSection> with SingleTickerProviderStateMixin{
  DateTime _dateTime;
  AnimationController _animationController;
  bool _isEndTimeExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 350),
      vsync: this,
    );

    _dateTime = DateTime.now();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                fontFamily: Constant.jostRegular
            ),
          ),
        ),
        SizedBox(height: 5,),
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
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          'Aug 16, 2020',
                          style: TextStyle(
                              color: Constant.splashColor,
                              fontFamily: Constant.jostRegular,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Text(
              Constant.at,
              style: TextStyle(
                  fontSize: 14,
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular
              ),
            ),
            SizedBox(width: 10,),
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Constant.backgroundTransparentColor,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          '10:30 AM',
                          style: TextStyle(
                              color: Constant.splashColor,
                              fontFamily: Constant.jostRegular,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Constant.end,
            style: TextStyle(
                fontSize: 14,
                color: Constant.locationServiceGreen,
                fontFamily: Constant.jostRegular
            ),
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
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                '${Utils.getShortMonthName(_dateTime.month)} ${_dateTime.day}, ${_dateTime.year}',
                                style: TextStyle(
                                    color: Constant.splashColor,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    Constant.at,
                    style: TextStyle(
                        fontSize: 14,
                        color: Constant.locationServiceGreen,
                        fontFamily: Constant.jostRegular
                    ),
                  ),
                  SizedBox(width: 10,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Constant.backgroundTransparentColor,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                Utils.getTimeInAmPmFormat(_dateTime.hour, _dateTime.minute),
                                style: TextStyle(
                                    color: Constant.splashColor,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    Constant.reset,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Constant.jostRegular,
                        fontWeight: FontWeight.w500,
                        color: Constant.addCustomNotificationTextColor
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isEndTimeExpanded = !_isEndTimeExpanded;

                if(_isEndTimeExpanded) {
                  _dateTime = DateTime.now();
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });

            },
            child: Text(
              (_isEndTimeExpanded) ? Constant.tapHereIfInProgress :Constant.tapHereToEnd,
              style: TextStyle(
                  fontSize: 14,
                  color: Constant.addCustomNotificationTextColor,
                  fontFamily: Constant.jostRegular
              ),
            ),
          ),
        ),
      ],
    );
  }
}
