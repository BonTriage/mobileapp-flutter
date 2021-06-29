import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/ForgotPasswordModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';


class LoginScreenRepository{
  String url;

  Future<dynamic> loginServiceCall(String url, RequestMethod requestMethod) async {
    var album;
    try {
      var response = await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return album;
    }
  }

  Future<dynamic> forgotPasswordServiceCall(String url, RequestMethod requestMethod) async {
    try {
      var response = await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return forgotPasswordModelFromJson(response);
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> createAndDeletePushNotificationServiceCall(String url, RequestMethod requestMethod, String requestBody) async {
    try {
      var response = await NetworkService(url, requestMethod,requestBody).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
  }

}
