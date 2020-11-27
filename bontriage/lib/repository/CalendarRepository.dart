import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';


class CalendarRepository{
  String url;

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
      return "album";
    }
  }

}
