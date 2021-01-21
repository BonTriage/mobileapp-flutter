import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/models/OnGoingHeadacheDataModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';


class CalendarRepository{
  Future<dynamic> calendarTriggersServiceCall(String url, RequestMethod requestMethod) async {
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
    } catch (e) {
      return "album";
    }
  }

  Future<dynamic> onGoingHeadacheServiceCall(String url, RequestMethod requestMethod) async {
    var onGoingHeadacheData;
    try {
      var response =
      await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        onGoingHeadacheData = onGoingHeadacheDataModelDartFromJson(response);
        return onGoingHeadacheData;
      }
    } catch (e) {
      return onGoingHeadacheData;
    }
  }
}
