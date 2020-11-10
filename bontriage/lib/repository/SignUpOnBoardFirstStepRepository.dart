import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardAnswersRequestModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/WelcomeOnBoardProfileModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardFirstStepRepository {
  String url;

  Future<dynamic> serviceCall(String url, RequestMethod requestMethod) async {
    var client = http.Client();
    var album;
    try {
      var response =
          await NetworkService(url, requestMethod, _getPayload()).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        album = WelcomeOnBoardProfileModel.fromJson(json.decode(response));
        LocalQuestionnaire localQuestionnaire = LocalQuestionnaire();
        localQuestionnaire.eventType = Constant.firstEventStep;
        localQuestionnaire.questionnaires = response;
        localQuestionnaire.selectedAnswers = "";
        SignUpOnBoardProviders.db.insertQuestionnaire(localQuestionnaire);
        return album;
      }
    } catch (Exception) {
      return album;
    }
  }

  Future<dynamic> signUpFirstStepInfoObjectServiceCall(
      String url,
      RequestMethod requestMethod,
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    var client = http.Client();
    var album;
    try {
      String payload = await _setUserFirstStepSignUpPayload(
          signUpOnBoardSelectedAnswersModel);
      var response =
          await NetworkService(url, requestMethod, payload).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return response;
      }
    } catch (Exception) {
      return album;
    }
  }

  String _getPayload() {
    return jsonEncode(<String, String>{
      "event_type": "clinical_impression_short0",
      "mobile_user_id": "4214"
    });
  }

  Future<String> _setUserFirstStepSignUpPayload(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel =
        SignUpOnBoardAnswersRequestModel();
    signUpOnBoardAnswersRequestModel.eventType = "clinical_impression_short0";
    signUpOnBoardAnswersRequestModel.userId = int.parse(userProfileInfoData.userId);
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
}
