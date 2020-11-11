import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:mobile/models/AddHeadacheLogModel.dart';
import 'package:mobile/models/SignUpOnBoardAnswersRequestModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';


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
      var response = await NetworkService(url, requestMethod,
          _setUserAddHeadachePayload(signUpOnBoardSelectedAnswersModel))
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

  String _setUserAddHeadachePayload(
      SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel) {
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel =
    SignUpOnBoardAnswersRequestModel();
    signUpOnBoardAnswersRequestModel.eventType = "headache";
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
