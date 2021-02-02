import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardAnswersRequestModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class MoreMyProfileRepository {

  Future<dynamic> myProfileServiceCall(String url, RequestMethod requestMethod) async {
    try {
      var response = await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        List<ResponseModel> responseModelList = responseModelFromJson(response);
        if(responseModelList != null && responseModelList.length > 0)
          return responseModelList[0];
        else
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> editMyProfileServiceCall(String url, RequestMethod requestMethod, List<SelectedAnswers> selectedAnswerList) async {
    try {
      String payload = await _getProfileDataPayload(selectedAnswerList);
      var response = await NetworkService(url,requestMethod, payload).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return ResponseModel.fromJson(jsonDecode(response));
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserProfileInfoModel> getUserProfileInfoModel() async{
    return await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
  }

  Future<String>_getProfileDataPayload(List<SelectedAnswers> selectedAnswers) async {
    SignUpOnBoardAnswersRequestModel signUpOnBoardAnswersRequestModel = SignUpOnBoardAnswersRequestModel();
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    signUpOnBoardAnswersRequestModel.eventType = Constant.profileEventType;
    if (userProfileInfoData != null)
      signUpOnBoardAnswersRequestModel.userId = int.parse(userProfileInfoData.userId);
    else
      signUpOnBoardAnswersRequestModel.userId = 4214;
    signUpOnBoardAnswersRequestModel.calendarEntryAt = Utils.getDateTimeInUtcFormat(DateTime.now());
    signUpOnBoardAnswersRequestModel.updatedAt = Utils.getDateTimeInUtcFormat(DateTime.now());
    signUpOnBoardAnswersRequestModel.mobileEventDetails = [];
    try {
      selectedAnswers.forEach((model) {
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