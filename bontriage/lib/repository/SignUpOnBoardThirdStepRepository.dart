import 'dart:convert';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
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
      var response =
      await NetworkService(url, requestMethod, _getPayload()).serviceCall();
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

  String _getPayload() {
    return jsonEncode(<String, String>{
      "event_type": eventTypeName,
      "mobile_user_id": "4214"
    });
  }
}