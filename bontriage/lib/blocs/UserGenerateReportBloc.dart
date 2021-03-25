import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/UserGenerateReportDataModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/LoginScreenRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserGenerateReportBloc {
  LoginScreenRepository _loginScreenRepository;
  StreamController<dynamic> _userGenerateReportStreamController;
  int count = 0;
  UserGenerateReportDataModel _userGenerateReportDataModel = UserGenerateReportDataModel();

  StreamSink<String> get userGenerateReportDataSink =>
      _userGenerateReportStreamController.sink;

  Stream<String> get changePasswordDataStream =>
      _userGenerateReportStreamController.stream;

  UserGenerateReportBloc({this.count = 0}) {
    _userGenerateReportStreamController = StreamController<String>();

    _userGenerateReportStreamController = StreamController<String>();
    _loginScreenRepository = LoginScreenRepository();
  }
//http://34.222.200.187:8080/mobileapi/v0/report?mobile_user_id=4678&start_date=2021-3-24T00:00:00Z&end_date=2021-3-10T00:00:00Z
//http://34.222.200.187:8080/mobileapi/v0/report?mobile_user_id=4642&start_date=2021-3-1T00:00:00Z&end_date=2021-3-31T00:00:00Z
  /// This method.
  Future<dynamic> getUserGenerateReportData(String startTime, String endTime) async {
    String apiResponse;
    var userProfileInfoData =
    await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'report?' +
          "mobile_user_id=" +
          userProfileInfoData.userId +
          "&" +
          "start_date=" +
          startTime +
          "&" +
          "end_date=" +
          endTime;
      var response =
      await _loginScreenRepository.loginServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        userGenerateReportDataSink.addError(response);
        apiResponse = response.toString();
        print(apiResponse.toString());
      } else {
          _userGenerateReportDataModel = UserGenerateReportDataModel.fromJson(json.decode(response));
          userGenerateReportDataSink.add(Constant.success);
          apiResponse = _userGenerateReportDataModel.map.base64;
      }
    } catch (e) {
      userGenerateReportDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e.toString());
    }
    return apiResponse;
  }

  void enterSomeDummyDataToStreamController() {
    userGenerateReportDataSink.add(Constant.loading);
  }

  void dispose() {
    _userGenerateReportStreamController?.close();
    _userGenerateReportStreamController?.close();
  }

  void inItNetworkStream() {
    _userGenerateReportStreamController?.close();
    _userGenerateReportStreamController = StreamController<dynamic>();
  }

}
