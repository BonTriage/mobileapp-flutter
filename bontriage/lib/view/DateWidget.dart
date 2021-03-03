import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/models/UserLogHeadacheDataCalendarModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class DateWidget extends StatelessWidget {
  final DateTime weekDateData;
  final int calendarType;
  final int calendarDateViewType;
  final List<SignUpHeadacheAnswerListModel> triggersListData;
  final List<SignUpHeadacheAnswerListModel> userMonthTriggersListData;
  final SelectedDayHeadacheIntensity selectedDayHeadacheIntensity;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;

  DateWidget(
      {this.weekDateData,
      this.calendarType,
      this.calendarDateViewType,
      this.triggersListData,
      this.userMonthTriggersListData,
      this.selectedDayHeadacheIntensity,
      this.navigateToOtherScreenCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Duration duration = weekDateData.difference(DateTime.tryParse(Utils.getDateTimeInUtcFormat(DateTime.now())));
                if (duration.inSeconds <= 0)
                  navigateToOtherScreenCallback(
                      Constant.onCalendarHeadacheLogDayDetailsScreenRouter,
                      weekDateData);
              },
              child: Container(
                height: 28,
                width: 28,
                decoration: setDateViewWidget(calendarDateViewType),
                padding: EdgeInsets.all(2),
                child: Center(
                  child: Text(
                    weekDateData.day.toString(),
                    style: setTextViewStyle(calendarDateViewType),
                  ),
                ),
              ),
            ),
            setTriggersViewOne(calendarType, triggersListData.length),
            setTriggersViewTwo(calendarType, triggersListData.length),
            setTriggersViewThree(calendarType, triggersListData.length),
            Visibility(
              visible: calendarType == 0 ? false : calendarType == 2,
              child: Container(
                width: 31,
                height: 31,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 1, right: 3),
                    width: 16,
                    height: 8,
                    decoration: BoxDecoration(
                      color: setIntensityTriggerColor(),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isCurrentDate() {
    DateTime now = new DateTime.now();
    return weekDateData.month == now.month &&
        weekDateData.year == now.year &&
        now.day.toString() == weekDateData.day.toString();
  }

  BoxDecoration setDateViewWidget(int calendarDateViewType) {
    if (calendarDateViewType == 0) {
      return BoxDecoration(
          color: ((selectedDayHeadacheIntensity != null ) ? selectedDayHeadacheIntensity.isMigraine ?? false : false)
              ? Constant.migraineColor
              : Constant.chatBubbleGreen,
          shape: BoxShape.circle,
          border: Border.all(
            color: ((selectedDayHeadacheIntensity != null ) ? selectedDayHeadacheIntensity.isMigraine ?? false : false)
                ? Constant.migraineColor
                : isCurrentDate()
                    ? Constant.currentDateColor
                    : Constant.chatBubbleGreen,
            width: 2,
          ));
    } else if (calendarDateViewType == 1) {
      return BoxDecoration(
          color: isCurrentDate()
              ? Constant.currentDateColor
              : Constant.backgroundTransparentColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCurrentDate()
                ? Constant.currentDateColor
                : Constant.chatBubbleGreen,
            width: 2,
          ));
    } else {
      return BoxDecoration(
        color: isCurrentDate() ? Constant.currentDateColor : Colors.transparent,
        shape: BoxShape.circle,
      );
    }
  }

  TextStyle setTextViewStyle(int calendarDateViewType) {
    if (calendarDateViewType == 0) {
      return TextStyle(
          fontSize: 15,
          color: isCurrentDate() ? Colors.white : Colors.black,
          fontFamily: Constant.jostRegular);
    } else if (calendarDateViewType == 1) {
      return TextStyle(
          fontSize: 15,
          color: isCurrentDate() ? Colors.white : Constant.locationServiceGreen,
          fontFamily: Constant.jostRegular);
    } else {
      return TextStyle(
          fontSize: 15,
          color: isCurrentDate() ? Colors.white : Constant.locationServiceGreen,
          fontFamily: Constant.jostRegular);
    }
  }

// 0- Red
  // 1-Purple
  //2 - Blue
  Visibility setTriggersViewOne(int calendarType, int triggersCount) {
    if (calendarType == 1) {
      if (triggersCount == 1 || triggersCount == 2 || triggersCount >= 3) {
        return Visibility(
          visible: checkVisibilityForDateTriggers(0),
          child: Container(
            width: 31,
            height: 31,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(top: 3, left: 5.5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Constant.bubbleChatTextView, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffD85B00)),
              ),
            ),
          ),
        );
      } else {
        return Visibility(
          visible: false,
          child: Container(),
        );
      }
    } else {
      return Visibility(
        visible: false,
        child: Container(),
      );
    }
  }

  Visibility setTriggersViewTwo(int calendarType, int triggersCount) {
    if (calendarType == 1) {
      if (triggersCount == 1 || triggersCount == 2 || triggersCount >= 3) {
        return Visibility(
          visible: checkVisibilityForDateTriggers(1),
          child: Container(
            width: 31,
            height: 31,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(top: 3, right: 5.5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Constant.bubbleChatTextView, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0XFF7E00CB)),
              ),
            ),
          ),
        );
      } else {
        return Visibility(
          visible: false,
          child: Container(),
        );
      }
    } else {
      return Visibility(
        visible: false,
        child: Container(),
      );
    }
  }

  Visibility setTriggersViewThree(int calendarType, int triggersCount) {
    if (calendarType == 1) {
      if (triggersCount == 1 || triggersCount == 2 || triggersCount >= 3) {
        return Visibility(
          visible: checkVisibilityForDateTriggers(2),
          child: Container(
            width: 31,
            height: 31,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Constant.bubbleChatTextView, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0XFF00A8CD)),
              ),
            ),
          ),
        );
      } else {
        return Visibility(
          visible: false,
          child: Container(),
        );
      }
    } else {
      return Visibility(
        visible: false,
        child: Container(),
      );
    }
  }

  bool checkVisibilityForDateTriggers(int colorValue) {
    bool isVisible = false;
    switch (colorValue) {
      case 0:
        triggersListData.forEach((element) {
          var filteredTriggersData = userMonthTriggersListData.firstWhere(
              (triggersElement) =>
                  triggersElement.answerData == element.answerData,
              orElse: () => null);
          if (filteredTriggersData != null &&
              filteredTriggersData.color != null) {
            if (filteredTriggersData.color ==
                    Constant.calendarRedTriggerColor &&
                filteredTriggersData.isSelected) {
              isVisible = true;
            }
          }
        });
        break;
      case 1:
        triggersListData.forEach((element) {
          var filteredTriggersData = userMonthTriggersListData.firstWhere(
              (triggersElement) =>
                  triggersElement.answerData == element.answerData,
              orElse: () => null);
          if (filteredTriggersData != null &&
              filteredTriggersData.color != null) {
            if (filteredTriggersData.color ==
                    Constant.calendarPurpleTriggersColor &&
                filteredTriggersData.isSelected) {
              isVisible = true;
            }
          }
        });
        break;
      case 2:
        triggersListData.forEach((element) {
          var filteredTriggersData = userMonthTriggersListData.firstWhere(
              (triggersElement) =>
                  triggersElement.answerData == element.answerData,
              orElse: () => null);
          if (filteredTriggersData != null &&
              filteredTriggersData.color != null) {
            if (filteredTriggersData.color ==
                    Constant.calendarBlueTriggersColor &&
                filteredTriggersData.isSelected) {
              isVisible = true;
            }
          }
        });
        break;
    }
    return isVisible && (calendarType == 0 ? false : calendarType == 1);
  }

  /// Mild - from 1 to 3
  /// Moderate - from 4 to 7
  /// Severe - from 8 to 10
  Color setIntensityTriggerColor() {
    if (selectedDayHeadacheIntensity != null &&
        selectedDayHeadacheIntensity.intensityValue != null) {
      int intensityValue =
          int.parse(selectedDayHeadacheIntensity.intensityValue);
      if (intensityValue >= 1 && intensityValue <= 3) {
        return Constant.mildTriggerColor;
      } else if (intensityValue >= 4 && intensityValue <= 7) {
        return Constant.moderateTriggerColor;
      } else if (intensityValue >= 8 && intensityValue <= 10) {
        return Constant.severeTriggerColor;
      } else
        return Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }
}
