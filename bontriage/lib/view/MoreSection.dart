import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/MoreHeadacheScreenArgumentModel.dart';
import 'package:mobile/models/MoreMedicationArgumentModel.dart';
import 'package:mobile/models/MoreTriggerArgumentModel.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChangePasswordScreen.dart';

class MoreSection extends StatefulWidget {
  final String text;
  final String moreStatus;
  final bool isShowDivider;
  final String currentTag;
  final Function(String, dynamic) navigateToOtherScreenCallback;
  final List<SelectedAnswers> selectedAnswerList;
  final HeadacheTypeData headacheTypeData;
  final MoreTriggersArgumentModel moreTriggersArgumentModel;
  final MoreMedicationArgumentModel moreMedicationArgumentModel;
  final Function viewReportClickedCallback;

  const MoreSection({Key key, this.text, this.moreStatus, this.isShowDivider, this.currentTag, this.navigateToOtherScreenCallback, this.selectedAnswerList, this.headacheTypeData, this.moreTriggersArgumentModel, this.moreMedicationArgumentModel, this.viewReportClickedCallback}) : super(key: key);
  @override
  _MoreSectionState createState() => _MoreSectionState();
}

class _MoreSectionState extends State<MoreSection> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  AnimationController _animationController;
  int clickedOnWhichButton = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      reverseDuration: Duration(milliseconds: 350),
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if(widget.currentTag != null) {
                switch(widget.currentTag) {
                  case Constant.settings:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreSettingRoute, null);
                    break;
                  case Constant.generateReport:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreGenerateReportRoute, null);
                    break;
                  case Constant.support:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreSupportRoute, null);
                    break;
                  case Constant.myProfile:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreMyProfileScreenRoute, null);
                    break;
                  case Constant.notifications:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreNotificationScreenRoute, null);
                    break;
                  case Constant.faq:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreFaqScreenRoute, null);
                    break;
                  case Constant.headacheType:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreHeadachesScreenRoute, MoreHeadacheScreenArgumentModel(headacheTypeData: widget.headacheTypeData));
                    break;
                  case Constant.locationServices:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreLocationServicesScreenRoute, null);
                    break;
                  case Constant.profileFirstNameTag:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreNameScreenRoute, widget.selectedAnswerList);
                    break;
                  case Constant.profileAgeTag:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreAgeScreenRoute, widget.selectedAnswerList);
                    break;
                  case Constant.profileGenderTag:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreGenderScreenRoute, widget.selectedAnswerList);
                    break;
                  case Constant.profileSexTag:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreSexScreenRoute, widget.selectedAnswerList);
                    break;
                  case Constant.myTriggers:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreTriggersScreenRoute, widget.moreTriggersArgumentModel);
                    break;
                  case Constant.myMedications:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreMedicationsScreenRoute, widget.moreMedicationArgumentModel);
                    break;
                  case Constant.dailyLog:
                  case Constant.medication:
                  case Constant.exercise:
                    if (!isExpanded) {
                      isExpanded = true;
                      _animationController.forward();
                    }
                    else {
                      isExpanded = false;
                      _animationController.reverse();
                    }
                    break;
                  case Constant.contactTheMigraineMentorTeam:
                    Utils.customLaunch('mailto:support@bontriage.com');
                    break;
                  case Constant.dateRange:
                    widget.navigateToOtherScreenCallback(Constant.dateRangeActionSheet, null);
                    break;
                  case Constant.viewReport:
                    widget.viewReportClickedCallback();
                    break;
                  /*case Constant.profileEmailTag:
                    widget.navigateToOtherScreenCallback(TabNavigatorRoutes.moreEmailScreenRoute, widget.selectedAnswerList);
                    break;*/
                  case Constant.changePassword:
                    widget.navigateToOtherScreenCallback(Constant.changePasswordScreenRouter, null);
                    break;
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                        color: Constant.locationServiceGreen,
                        fontSize: 16,
                        fontFamily: Constant.jostRegular
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          child: Text(
                            widget.moreStatus,
                            style: TextStyle(
                                color: Constant.notificationTextColor,
                                fontSize: 15,
                                fontFamily: Constant.jostMedium
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                          alignment: Alignment.topRight,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Image(
                        width: 16,
                        height: 16,
                        image: AssetImage(Constant.rightArrow),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _animationController,
            child: _getExpandableWidget(),
          ),
          Visibility(
            visible: widget.isShowDivider,
            child: Divider(
              color: Constant.locationServiceGreen,
              thickness: 1,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getExpandableWidget() {
    switch(widget.currentTag) {
      case Constant.dailyLog:
      case Constant.medication:
      case Constant.exercise:
        return Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            clickedOnWhichButton = 0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: (clickedOnWhichButton == 0) ? Constant.selectedNotificationColor : Colors.transparent
                          ),
                          child: Text(
                            'Daily',
                            style: TextStyle(
                                fontSize: 10,
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostRegular
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
                            clickedOnWhichButton = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: (clickedOnWhichButton == 1) ? Constant.selectedNotificationColor : Colors.transparent
                          ),
                          child: Text(
                            'Weekdays',
                            style: TextStyle(
                                fontSize: 10,
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostRegular
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clickedOnWhichButton = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Constant.chatBubbleGreen, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: (clickedOnWhichButton == 2) ? Constant.selectedNotificationColor : Colors.transparent
                      ),
                      child: Text(
                        'Off',
                        style: TextStyle(
                            fontSize: 10,
                            color: Constant.chatBubbleGreen,
                            fontFamily: Constant.jostRegular
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(fontSize: 18, color: Constant.locationServiceGreen, fontFamily: Constant.jostRegular),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    backgroundColor: Colors.transparent,
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: false,
                    onDateTimeChanged: (dateTime) {

                    },
                  ),
                ),
              ),
              Text(
                Constant.reset,
                style: TextStyle(
                  color: Constant.addCustomNotificationTextColor,
                  fontSize: 12,
                  fontFamily: Constant.jostRegular
                ),
              ),
            ],
          ),
        );
        break;
      default:
        return Container();
    }
  }
}
