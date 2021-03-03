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
        //response = '[{"id":1620,"user_id":4626,"uploaded_at":"2021-02-05T09:07:07Z","updated_at":"2021-02-05T09:07:07Z","calendar_entry_at":"2021-02-05T09:07:07Z","event_type":"profile","mobile_event_details":[{"id":8681,"event_id":1620,"value":"28.6351565%@77.1223014","question_tag":"profile.location","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8684,"event_id":1620,"value":"Test249","question_tag":"profile.firstname","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8683,"event_id":1620,"value":"Man","question_tag":"profile.gender","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8682,"event_id":1620,"value":"Male","question_tag":"profile.sex","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8685,"event_id":1620,"value":"23","question_tag":"profile.age","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"}],"headache_list":[{"value_number":"1626","text":"Headache1","is_valid":true}],"trigger_medication_values":[{"id":1620,"user_id":4626,"uploaded_at":"2021-02-05T09:07:07Z","updated_at":"2021-02-05T09:07:07Z","calendar_entry_at":"2021-02-05T09:07:07Z","event_type":"clinical_impression_short3","mobile_event_details":[{"id":8681,"event_id":1620,"value":"Answer 1%@Answer 3","question_tag":"headache.devices","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8684,"event_id":1620,"value":"Stress%@caffeine%@alcohol","question_tag":"headache.trigger","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8683,"event_id":1620,"value":"acetaminophen%@aspirin","question_tag":"headache.medications","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8682,"event_id":1620,"value":"Answer 1","question_tag":"headache.lifestyle","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"},{"id":8685,"event_id":1620,"value":"","question_tag":"headache.prevent","question_json":"","uploaded_at":"2021-02-05T09:07:09Z","updated_at":"2021-02-05T09:07:07Z"}]}],"trigger_values":[{"value_number":"1","text":"Stress","is_valid":true},{"value_number":"2","text":"weather change","is_valid":true},{"value_number":"3","text":"caffeine","is_valid":true},{"value_number":"4","text":"menses","is_valid":true},{"value_number":"5","text":"alcohol","is_valid":true},{"value_number":"6","text":"not eating on time","is_valid":true},{"value_number":"7","text":"head trauma","is_valid":true},{"value_number":"8","text":"lack of or irregular sleep","is_valid":true},{"value_number":"9","text":" medication overuse","is_valid":true},{"value_number":"10","text":"light","is_valid":true},{"value_number":"11","text":"smell","is_valid":true},{"value_number":"12","text":"None of the above","is_valid":false}],"medication_values":[{"value_number":"1","text":"acetaminophen","is_valid":true},{"value_number":"2","text":"aspirin","is_valid":true},{"value_number":"3","text":"non steroidal anti-inflammatory drugs","is_valid":true},{"value_number":"4","text":"triptans","is_valid":true},{"value_number":"5","text":"ergots","is_valid":true},{"value_number":"6","text":"gepants","is_valid":true},{"value_number":"7","text":"anti-nausea medications","is_valid":true},{"value_number":"8","text":"pain medication","is_valid":true},{"value_number":"9","text":"None of the above","is_valid":false}]}]';
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

    DateTime dateTime = DateTime.now();
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    signUpOnBoardAnswersRequestModel.eventType = Constant.profileEventType;
    if (userProfileInfoData != null)
      signUpOnBoardAnswersRequestModel.userId = int.parse(userProfileInfoData.userId);
    else
      signUpOnBoardAnswersRequestModel.userId = 4214;
    signUpOnBoardAnswersRequestModel.calendarEntryAt = Utils.getDateTimeInUtcFormat(dateTime);
    signUpOnBoardAnswersRequestModel.updatedAt = Utils.getDateTimeInUtcFormat(dateTime);
    signUpOnBoardAnswersRequestModel.mobileEventDetails = [];
    try {
      selectedAnswers.forEach((model) {
        signUpOnBoardAnswersRequestModel.mobileEventDetails.add(
            MobileEventDetails(
                questionTag: model.questionTag,
                questionJson: "",
                updatedAt: Utils.getDateTimeInUtcFormat(dateTime),
                value: [model.answer]));
      });
    } catch (e) {
      print(e);
    }

    return jsonEncode(signUpOnBoardAnswersRequestModel);
  }
}