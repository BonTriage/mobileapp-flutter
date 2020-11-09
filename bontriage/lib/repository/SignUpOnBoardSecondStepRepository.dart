import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardAnswersRequestModel.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardFirstStepRepository {
  String url;
  String eventTypeName;

  Future<dynamic> serviceCall(
      String url, RequestMethod requestMethod, String argumentsName) async {
    var client = http.Client();
    var album;
    try {
      eventTypeName = argumentsName;
      var response =
          await NetworkService(url, requestMethod, _getPayload()).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        album = SignUpOnBoardSecondStepModel.fromJson(json.decode(response));
        LocalQuestionnaire localQuestionnaire = LocalQuestionnaire();
        localQuestionnaire.eventType = Constant.secondEventStep;
        localQuestionnaire.questionnaires = response;
        localQuestionnaire.selectedAnswers = "";
        SignUpOnBoardProviders.db.insertQuestionnaire(localQuestionnaire);
        return album;
      }
    } catch (Exception) {
      return album;
    }
  }

  Future<dynamic> signUpWelcomeOnBoardSecondStepServiceCall(
      String url,
      RequestMethod requestMethod,
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    var client = http.Client();
    var album;
    try {
      var response = await NetworkService(url, requestMethod,
              _setUserSecondStepPayload(signUpOnBoardSelectedAnswersModel))
          .serviceCall();
      if (response is AppException) {
        return response;
      } else {
        //album = WelcomeOnBoardProfileModel.fromJson(json.decode(response));

        return response;
      }
    } catch (Exception) {
      return album;
    }
  }

  Future<String> _setUserSecondStepPayload(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel =
        SignUpOnBoardAnswersRequestModel();
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    signUpOnBoardAnswersRequestModel.eventType =
        Constant.clinicalImpressionShort1;
    signUpOnBoardAnswersRequestModel.userId = userProfileInfoData.userId as int;
    signUpOnBoardAnswersRequestModel.calendarEntryAt = "2020-10-08T08:17:51Z";
    signUpOnBoardAnswersRequestModel.updatedAt = "2020-10-08T08:18:21Z";
    signUpOnBoardAnswersRequestModel.mobileEventDetails = [];
    try {
      signUpOnBoardSelectedAnswersModel.selectedAnswers.forEach((model) {
        signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
            MobileEventDetails(
                questionTag: model.questionTag,
                questionJson: "",
                updatedAt: "2020-10-08T08:18:21Z",
                value: [model.answer]));
      });
    } catch (e) {
      print(e);
    }

    return jsonEncode(signUpOnBoardAnswersRequestModel);
  }

  Future<String> _getPayload() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    return jsonEncode(<String, String>{
      "event_type": eventTypeName,
      "mobile_user_id": "4551"
    });
  }
}
