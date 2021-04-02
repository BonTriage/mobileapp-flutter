import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/RecordsCompassAxesResultModel.dart';
import 'package:mobile/models/UserGenerateReportDataModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/SignUpSecondStepCompassRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class SignUpSecondStepCompassBloc {
  SignUpSecondStepCompassRepository _repository;
  StreamController<dynamic> _recordsCompassStreamController;
  StreamController<dynamic> _networkStreamController;

  StreamSink<dynamic> get recordsCompassDataSink =>
      _recordsCompassStreamController.sink;

  Stream<dynamic> get recordsCompassDataStream =>
      _recordsCompassStreamController.stream;

  Stream<dynamic> get networkDataStream => _networkStreamController.stream;

  StreamSink<dynamic> get networkDataSink => _networkStreamController.sink;

  StreamController<dynamic> _viewReportStreamController;

  Stream<dynamic> get viewReportStream => _viewReportStreamController.stream;
  StreamSink<dynamic> get viewReportSink => _viewReportStreamController.sink;

  SignUpSecondStepCompassBloc() {
    _repository = SignUpSecondStepCompassRepository();
    _recordsCompassStreamController = StreamController<dynamic>();
    _networkStreamController = StreamController<dynamic>();
    _viewReportStreamController = StreamController<dynamic>();
  }

  Future<void> fetchFirstLoggedScoreData() async {
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      print('USERID????${userProfileInfoData.userId}');
      String url = '${WebservicePost.qaServerUrl}compass/profile/${userProfileInfoData.userId}';
      var response = await _repository.serviceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        networkDataSink.addError(response);
      } else {
        if (response != null) {
          RecordsCompassAxesResultModel recordsCompareCompassAxesResultModel = RecordsCompassAxesResultModel.fromJson(jsonDecode(response));
          recordsCompassDataSink.add(recordsCompareCompassAxesResultModel);
          networkDataSink.add(Constant.success);
        } else {
          networkDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      networkDataSink.addError(Exception(Constant.somethingWentWrong));
    }
  }

  Future<dynamic> getUserGenerateReportData(String startTime, String endTime, String headacheName) async {
    String apiResponse;
    var userProfileInfoData =
    await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = '${WebservicePost.qaServerUrl}report?mobile_user_id=${userProfileInfoData.userId}&start_date=$startTime&end_date=$endTime&headache_name=$headacheName';
      var response = await _repository.callServiceForViewReport(url, RequestMethod.GET);
      if (response is AppException) {
        networkDataSink.addError(response);
        print(apiResponse.toString());
      } else {
        print(response);
        if(response != null && response is UserGenerateReportDataModel) {
          networkDataSink.add(Constant.success);
          viewReportSink.add(response);
        } else {
          networkDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      networkDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e.toString());
    }
    return apiResponse;
  }


  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void enterDummyDataToNetworkStream() {
    networkDataSink.add(Constant.loading);
  }

  void dispose() {
    _recordsCompassStreamController?.close();
    _networkStreamController?.close();
    _viewReportStreamController?.close();
  }
}