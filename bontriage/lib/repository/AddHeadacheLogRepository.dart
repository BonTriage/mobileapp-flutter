import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:mobile/models/AddHeadacheLogModel.dart';
import 'package:mobile/models/SignUpOnBoardAnswersRequestModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';


class AddHeadacheLogRepository{
  String url;

  Future<dynamic> serviceCall(String url, RequestMethod requestMethod) async{
    var client = http.Client();
    var album;
    try {
      String payload = await _getPayload();
      var response = await NetworkService(url,requestMethod, payload).serviceCall();
      if(response is AppException){
        return response;
      }else{
        album = AddHeadacheLogModel.fromJson(json.decode(response));
        return album;
      }
    }catch(Exception){
      return album;
    }
  }

  Future<dynamic> userAddHeadacheObjectServiceCall(
      String url,
      RequestMethod requestMethod,
      SignUpOnBoardSelectedAnswersModel
      signUpOnBoardSelectedAnswersModel) async {
    var client = http.Client();
    var album;
    try {
      String payload = await _setUserAddHeadachePayload(signUpOnBoardSelectedAnswersModel);
      var response = await NetworkService(url, requestMethod,
          payload)
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

  Future<String> _setUserAddHeadachePayload(
      SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel) async{
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel =
    SignUpOnBoardAnswersRequestModel();
    signUpOnBoardAnswersRequestModel.eventType = "headache";
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    if(userProfileInfoData != null) {
      signUpOnBoardAnswersRequestModel.userId = int.parse(userProfileInfoData.userId);
    } else {
      signUpOnBoardAnswersRequestModel.userId = 4214;
    }
    DateTime dateTime = DateTime.now();
    signUpOnBoardAnswersRequestModel.calendarEntryAt = Utils.getDateTimeInUtcFormat(DateTime(dateTime.year, dateTime.month, dateTime.day - 2));
    signUpOnBoardAnswersRequestModel.updatedAt = Utils.getDateTimeInUtcFormat(DateTime.now());
    signUpOnBoardAnswersRequestModel.mobileEventDetails = [];
    try {
      signUpOnBoardSelectedAnswersModel.selectedAnswers.forEach((model) {
        signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
            MobileEventDetails(
                questionTag: model.questionTag,
                questionJson: "",
                updatedAt: Utils.getDateTimeInUtcFormat(DateTime.now()),
                value: [model.answer]));
      });
    } catch (e) {
      print(e);
    }

    return jsonEncode(signUpOnBoardAnswersRequestModel);
  }


  Future<List<Map>> getAllHeadacheDataFromDatabase(String userId) async{
    List<Map> userLogDataMap = await SignUpOnBoardProviders.db.getUserHeadacheData(userId);
    return userLogDataMap;
  }

  Future<String> _getPayload() async{
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    return jsonEncode(<String, String>{
      "event_type": "headache", "mobile_user_id": userProfileInfoData.userId
    });
  }
}
