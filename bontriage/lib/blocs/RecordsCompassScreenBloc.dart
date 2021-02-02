import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/RecordsCompareCompassModel.dart';
import 'package:mobile/models/RecordsCompassAxesResultModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/LoginScreenRepository.dart';
import 'package:mobile/repository/RecordsCompassRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/util/constant.dart';

class RecordsCompassScreenBloc {
  RecordsCompassRepository _recordsCompassRepository;
  StreamController<dynamic> _recordsCompassStreamController;
  StreamController<dynamic> _networkStreamController;
  int count = 0;

  StreamSink<dynamic> get recordsCompassDataSink =>
      _recordsCompassStreamController.sink;

  Stream<dynamic> get recordsCompassDataStream =>
      _recordsCompassStreamController.stream;

  Stream<dynamic> get networkDataStream => _networkStreamController.stream;

  StreamSink<dynamic> get networkDataSink => _networkStreamController.sink;

  RecordsCompassAxesResultModel recordsCompassAxesResultModel;

  RecordsCompareCompassModel _recordsCompareCompassModel = RecordsCompareCompassModel();

  RecordsCompassScreenBloc({this.count = 0}) {
    _recordsCompassStreamController = StreamController<dynamic>();
    _recordsCompassRepository = RecordsCompassRepository();
    _networkStreamController  = StreamController<dynamic>();
  }

  fetchOverTimeCompassAxesResult(
      String startDate, String endDate, String headacheName) async {
    String apiResponse;
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'compass/calender/?' +
          "start_date=" +
          startDate +
          "&" +
          "end_date=" +
          endDate +
          '&' +
          'user_id=' +
          userProfileInfoData.userId +
          '&' +
          'headache_name=' +
          headacheName;
      var response = await _recordsCompassRepository.compassServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        recordsCompassDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if (response != null) {
          recordsCompassAxesResultModel =
              RecordsCompassAxesResultModel.fromJson(jsonDecode(response));
          recordsCompassDataSink.add(recordsCompassAxesResultModel);
        } else {
          recordsCompassDataSink
              .addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      recordsCompassDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  fetchCompareCompassAxesResult(
      String startDate, String endDate, String headacheName) async {
    String apiResponse;
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'compass/calender/?' +
          "start_date=" +
          startDate +
          "&" +
          "end_date=" +
          endDate +
          '&' +
          'user_id=' +
          userProfileInfoData.userId +
          '&' +
          'headache_name=' +
          headacheName;
      var response = await _recordsCompassRepository.compassServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        recordsCompassDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if (response != null) {
          _recordsCompareCompassModel.recordsCompareCompassAxesResultModel =
              RecordsCompassAxesResultModel.fromJson(jsonDecode(response));
          await fetchFirstLoggedCompassAxesResult();
        } else {
          recordsCompassDataSink
              .addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      recordsCompassDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  //http://localhost:8080/mobileapi/v0/compass/profile/4579
  fetchFirstLoggedCompassAxesResult() async {
    String apiResponse;
    var userProfileInfoData =  await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'compass/profile/' +
          '4579';
      var response = await _recordsCompassRepository.compassServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        recordsCompassDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if (response != null) {
          _recordsCompareCompassModel.signUpCompassAxesResultModel =
              RecordsCompassAxesResultModel.fromJson(jsonDecode(response));
          recordsCompassDataSink.add(_recordsCompareCompassModel);
        } else {
          recordsCompassDataSink
              .addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      recordsCompassDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  void enterSomeDummyDataToStreamController() {
    networkDataSink.add(Constant.loading);
  }

  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void dispose() {
    _recordsCompassStreamController?.close();
    _networkStreamController?.close();
  }
}
