import 'dart:convert';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardAnswersRequestModel.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardThirdStepRepository {
  String eventTypeName;

  Future<dynamic> serviceCall(
      String url, RequestMethod requestMethod, String argumentsName) async {
    var client = http.Client();
    var album;
    try {
      eventTypeName = argumentsName;
      String payload = await _getPayload();
      var response =
          await NetworkService(url, requestMethod,payload).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        album = SignUpOnBoardSecondStepModel.fromJson(json.decode(response));
        LocalQuestionnaire localQuestionnaire = LocalQuestionnaire();
        localQuestionnaire.eventType = Constant.thirdEventStep;
        localQuestionnaire.questionnaires = response;
        localQuestionnaire.selectedAnswers = "";
        SignUpOnBoardProviders.db.insertQuestionnaire(localQuestionnaire);
        return album;
      }
    } catch (Exception) {
      return album;
    }
  }

  Future<dynamic> signUpThirdStepInfoObjectServiceCall(
      String url,
      RequestMethod requestMethod,
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    var client = http.Client();
    var album;
    try {
      var dataPayload =
          await _setSignUpThirdStepPayload(signUpOnBoardSelectedAnswersModel);
      var response =
          await NetworkService(url, requestMethod, dataPayload).serviceCall();
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

  Future<String> _setSignUpThirdStepPayload(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel =
        SignUpOnBoardAnswersRequestModel();
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    signUpOnBoardAnswersRequestModel.eventType =
        Constant.clinicalImpressionShort3;
    if(userProfileInfoData != null)
      signUpOnBoardAnswersRequestModel.userId = userProfileInfoData.userId as int;
    else
      signUpOnBoardAnswersRequestModel.userId = 4214;
    signUpOnBoardAnswersRequestModel.calendarEntryAt = "2020-10-08T08:17:51Z";
    signUpOnBoardAnswersRequestModel.updatedAt = "2020-10-08T08:18:21Z";
    signUpOnBoardAnswersRequestModel.mobileEventDetails = [];
    try {
      signUpOnBoardSelectedAnswersModel.selectedAnswers.forEach((model) {
        try {
          var decodedJson = jsonDecode(model.answer);
          if (decodedJson is List<dynamic>) {
            List<String> valuesList = (json.decode(model.answer) as List<
                dynamic>).cast<String>();
            signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
                MobileEventDetails(
                    questionTag: model.questionTag,
                    questionJson: "",
                    updatedAt: "2020-10-08T08:18:21Z",
                    value: valuesList));
          } else {
            signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
                MobileEventDetails(
                    questionTag: model.questionTag,
                    questionJson: "",
                    updatedAt: "2020-10-08T08:18:21Z",
                    value: [model.answer]));
          }
        } on FormatException catch(e) {
          print(e.toString());
          //This catch is used to enter data in mobile event details list
          signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
              MobileEventDetails(
                  questionTag: model.questionTag,
                  questionJson: "",
                  updatedAt: "2020-10-08T08:18:21Z",
                  value: [model.answer]));
        }
      });
    } catch (e) {
      print(e);
    }

    return jsonEncode(signUpOnBoardAnswersRequestModel);
  }

  Future<String> _getPayload() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    if(userProfileInfoData != null) {
      return jsonEncode(<String, String>{
        "event_type": eventTypeName,
        "mobile_user_id": userProfileInfoData.userId
      });
    } else {
      return jsonEncode(<String, String>{
        "event_type": eventTypeName,
        "mobile_user_id": '4214'
      });
    }
  }
}
