import 'dart:convert';
import 'dart:math';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/LogDayQuestionnaire.dart';
import 'package:mobile/models/LogDayResponseModel.dart';
import 'package:mobile/models/WelcomeOnBoardProfileModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/providers/SignUpOnBoardProviders.dart';


class LogDayRepository {
  String url;
  String eventType;

  Future<dynamic> serviceCall(String url, RequestMethod requestMethod) async {
    var client = http.Client();
    var album;
    try {
      String payload = await _getPayload();
      var response = await NetworkService(url, requestMethod, payload).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        album = LogDayResponseModel.fromJson(json.decode(response));
        return album;
      }
    } catch (Exception) {
      return album;
    }
  }

  Future<String> _getPayload() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    return jsonEncode(
        <String, String>{"event_type": eventType, "mobile_user_id": userProfileInfoData.userId});
  }

  Future<List<Map>> getAllLogDayData(String userId) async{
    List<Map> userLogDataMap = await SignUpOnBoardProviders.db.getLogDayData(userId);
    return userLogDataMap;
  }
}