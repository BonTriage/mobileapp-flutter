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

class WelcomeOnBoardProfileRepository {
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
        localQuestionnaire.eventType = Constant.zeroEventStep;
        localQuestionnaire.questionnaires = response;
        localQuestionnaire.selectedAnswers = "";
        SignUpOnBoardProviders.db.insertQuestionnaire(localQuestionnaire);
        return album;
      }
    } catch (Exception) {
      return album;
    }
  }

  Future<dynamic> signUpProfileInfoObjectServiceCall(
      String url,
      RequestMethod requestMethod,
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    var client = http.Client();
    var album;
    try {
      var response = await NetworkService(url, requestMethod,
              _setUserProfileSignUpPayload(signUpOnBoardSelectedAnswersModel))
          .serviceCall();
      if (response is AppException) {
        return response;
      } else {
        //album = WelcomeOnBoardProfileModel.fromJson(json.decode(response));

        return album;
      }
    } catch (Exception) {
      return album;
    }
  }

  String _getPayload() {
    return jsonEncode(
        <String, String>{"event_type": "profile", "mobile_user_id": "4214"});
  }

  String _setUserProfileSignUpPayload(
      SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel) {
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel =
        SignUpOnBoardAnswersRequestModel();
    signUpOnBoardAnswersRequestModel.eventType =
        signUpOnBoardSelectedAnswersModel.eventType;
    signUpOnBoardAnswersRequestModel.userId = 4551;
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
