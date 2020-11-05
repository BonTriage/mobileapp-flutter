import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class Utils {
  static String getMonthName(int monthNum) {
    String month = '';
    switch (monthNum) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    return month;
  }

  static String getShortMonthName(int monthNum) {
    String month = '';
    switch (monthNum) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sept";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }
    return month;
  }

  static String getTimeInAmPmFormat(int hours, int minutes) {
    String time = '';
    int hrs = hours;
    String hrsString = hours.toString();
    String minString = minutes.toString();
    String amPm = 'AM';

    if (hrs > 12) {
      hrs = hours % 12;
    }

    if (hrs < 10) {
      hrsString = '0$hrs';
    }

    if (minutes < 10) {
      minString = '0$minutes';
    }

    if (hours >= 12) {
      amPm = 'PM';
    }

    time = '$hrsString:$minString $amPm';

    return time;
  }

  static String getStringFromJson(dynamic jsonObject) {
    return jsonEncode(jsonObject);
  }

  Map<String, dynamic> _getJsonFromString(String response) {
    return json.decode(response);
  }

  static void saveTutorialsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constant.tutorialsState, true);
  }

  // this returns the last date of the month using DateTime
  static int daysInMonth(DateTime date) {
    var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  static Future<void> saveDataInSharedPreference(
      String keyName, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyName, value);
  }

  /// For Validate Email
  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  /// For Validate Password
  // r'^
  //   (?=.*[A-Z])       // should contain at least one upper case
  //   (?=.*[a-z])       // should contain at least one lower case
  //   (?=.*?[0-9])          // should contain at least one digit
  static bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  ///This method is used to validate the data of on-boarding
  static bool validationForOnBoard(
      List<SelectedAnswers> selectedAnswerList, Questions questions) {
    switch (questions.questionType) {
      case Constant.QuestionMultiType:
        if (selectedAnswerList != null) {
          SelectedAnswers selectedAnswersData = selectedAnswerList.firstWhere(
              (element) => element.questionTag == questions.tag,
              orElse: () => null);
          if (selectedAnswersData != null) {
            try {
              List<String> _valuesSelectedList =
                  (jsonDecode(selectedAnswersData.answer) as List<dynamic>)
                      .cast<String>();

              return _valuesSelectedList.length != 0;
            } catch (e) {
              print(e.toString());
              return false;
            }
          }
        } else {
          return false;
        }
        return false;
      case Constant.QuestionSingleType:
        if (selectedAnswerList != null) {
          SelectedAnswers selectedAnswersData = selectedAnswerList.firstWhere(
              (element) => element.questionTag == questions.tag,
              orElse: () => null);
          return (selectedAnswersData != null) &&
              selectedAnswersData.answer.trim().isNotEmpty;
        } else {
          return false;
        }
        break;
      case Constant.QuestionNumberType:
        if (selectedAnswerList != null) {
          SelectedAnswers selectedAnswersData = selectedAnswerList.firstWhere(
              (element) => element.questionTag == questions.tag,
              orElse: () => null);
          return (selectedAnswersData != null) &&
              selectedAnswersData.answer.trim().isNotEmpty;
        } else {
          return false;
        }
        break;
      case Constant.QuestionTextType:
        if (selectedAnswerList != null) {
          SelectedAnswers selectedAnswersData = selectedAnswerList.firstWhere(
              (element) => element.questionTag == questions.tag,
              orElse: () => null);
          return (selectedAnswersData != null) &&
              selectedAnswersData.answer.trim().isNotEmpty;
        } else {
          return false;
        }
        break;
      case Constant.QuestionLocationType:
        if (selectedAnswerList != null) {
          SelectedAnswers selectedAnswersData = selectedAnswerList.firstWhere(
              (element) => element.questionTag == questions.tag,
              orElse: () => null);
          return (selectedAnswersData != null) &&
              selectedAnswersData.answer.trim().isNotEmpty;
        } else {
          return false;
        }
        break;
      default:
        return true;
    }
  }

  ///This method is used to navigate the user to the screen where he/she left off.
  static void navigateToUserOnProfileBoard(BuildContext context) async {
    UserProgressDataModel userProgressModel =
        await SignUpOnBoardProviders.db.getUserProgress();
    if (userProgressModel != null) {
      switch (userProgressModel.step) {
        case Constant.zeroEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.signUpOnBoardProfileQuestionRouter);
          break;
        case Constant.firstEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.partOneOnBoardScreenTwoRouter);
          break;
        case Constant.firstCompassEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.signUpFirstStepHeadacheResultRouter);
          break;
        case Constant.secondCompassEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.signUpSecondStepHeadacheResultRouter);
          break;
        case Constant.secondEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.partTwoOnBoardScreenRouter);
          break;
        case Constant.thirdEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.partThreeOnBoardScreenRouter);
          break;
        case Constant.headacheInfoEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.onBoardHeadacheInfoScreenRouter);
          break;
        case Constant.createAccountEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.onBoardCreateAccountScreenRouter);
          break;
        case Constant.prePartTwoEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.prePartTwoOnBoardScreenRouter);
          break;
        case Constant.onBoardMoveOnForNowEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.partTwoOnBoardMoveOnScreenRouter);
          break;
        case Constant.prePartThreeEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.prePartThreeOnBoardScreenRouter);
          break;
        case Constant.postPartThreeEventStep:
          Navigator.pushReplacementNamed(
              context, Constant.postPartThreeOnBoardRouter);
          break;
        case Constant.notificationEventStep:
          Navigator.pushReplacementNamed(context, Constant.notificationScreenRouter);
          break;
        case Constant.postNotificationEventStep:
          Navigator.pushReplacementNamed(context, Constant.postNotificationOnBoardRouter);
          break;
        default:
          Navigator.pushReplacementNamed(
              context, Constant.signUpOnBoardSplashRouter);
      }
    } else {
      Navigator.pushReplacementNamed(
          context, Constant.signUpOnBoardSplashRouter);
    }
  }

  /// This method will be use for to get current tag from respective API and if the current table from database is empty then insert the
  /// data on respective position of the questions list.and if not then update the data on respective position.
  static void saveUserProgress(int userScreenPosition, String eventStep) async {
    var isDataBaseExists = await SignUpOnBoardProviders.db.isDatabaseExist();
    UserProgressDataModel userProgressDataModel = UserProgressDataModel();

    if(isDataBaseExists) {
      int userProgressDataCount = await SignUpOnBoardProviders.db
          .checkUserProgressDataAvailable(
          SignUpOnBoardProviders.TABLE_USER_PROGRESS);
      userProgressDataModel.userId = Constant.userID;
      userProgressDataModel.step = eventStep;
      userProgressDataModel.userScreenPosition = userScreenPosition;
      userProgressDataModel.questionTag = '';

      if (userProgressDataCount == 0) {
        SignUpOnBoardProviders.db.insertUserProgress(userProgressDataModel);
      } else {
        SignUpOnBoardProviders.db.updateUserProgress(userProgressDataModel);
      }
    }
  }
}
