import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/models/LogDayResponseModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
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

  Future<dynamic> logDaySubmissionDataServiceCall(String url, RequestMethod requestMethod, String payload) async{
    var response;
    try {
      response = await NetworkService(url, requestMethod, payload).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return response;
    }
  }

  Future<dynamic> calendarTriggersServiceCall(String url, RequestMethod requestMethod) async {
    var client = http.Client();
    var calendarData;
    try {
      var response =
      await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        calendarData = CalendarInfoDataModel.fromJson(json.decode(response));
        return calendarData;
      }
    } catch (Exception) {
      return calendarData;
    }
  }
}