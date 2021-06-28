import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/RecordsTrendsDataModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/RecordsTrendsRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/models/RecordsTrendsMultipleHeadacheDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordsTrendsScreenBloc {
  RecordsTrendsRepository _recordsTrendsRepository;
  StreamController<dynamic> _recordsTrendsStreamController;
  StreamController<dynamic> _networkStreamController;
  RecordsTrendsDataModel _recordsTrendsDataModel = RecordsTrendsDataModel();

  int count = 0;

  StreamSink<dynamic> get recordsTrendsDataSink =>
      _recordsTrendsStreamController.sink;

  Stream<dynamic> get recordsTrendsDataStream =>
      _recordsTrendsStreamController.stream;

  Stream<dynamic> get networkDataStream => _networkStreamController.stream;

  StreamSink<dynamic> get networkDataSink => _networkStreamController.sink;

  RecordsTrendsScreenBloc({this.count = 0}) {
    _recordsTrendsStreamController = StreamController<dynamic>();
    _recordsTrendsRepository = RecordsTrendsRepository();
    _networkStreamController = StreamController<dynamic>();
  }

  fetchAllHeadacheListData(
      String startDate, String endDate, String firstHeadacheName,String secondHeadacheName, bool isMultiPleHeadacheSelected) async {
    String apiResponse;
    var userProfileInfoData;
    if(!kIsWeb) {
      userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String userInfoJson = sharedPreferences.getString(Constant.userInfo);

      userProfileInfoData = userProfileInfoModelFromJson(userInfoJson);
    }
    try {
      String url = WebservicePost.qaServerUrl +
          'common/fetchheadaches/' +
          userProfileInfoData.userId;
      var response = await _recordsTrendsRepository.trendsServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        networkDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if (response != null) {
          var json = jsonDecode(response);
          List<HeadacheListDataModel> headacheListModelData = [];
          json.forEach((v) {
            headacheListModelData.add(new HeadacheListDataModel.fromJson(v));
          });

          if (headacheListModelData.length > 0) {
            _recordsTrendsDataModel.headacheListModelData =
                headacheListModelData;
            if (firstHeadacheName != null) {
              if(isMultiPleHeadacheSelected){
                getMultipleHeadacheTrendsDate(startDate, endDate, firstHeadacheName, secondHeadacheName);
              }else getTrendsUserData(startDate, endDate, firstHeadacheName);
            } else {
              getTrendsUserData(
                  startDate, endDate, headacheListModelData[0].text);
            }
          } else {
            networkDataSink.add(Constant.success);
            recordsTrendsDataSink.add(Constant.noHeadacheData);
          }
          print(headacheListModelData);
        } else {
          recordsTrendsDataSink.addError(Exception(Constant.somethingWentWrong));
          networkDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      networkDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }



//http://34.222.200.187:8080/mobileapi/v0/trends/event/?end_date=2021-01-31T18:30:00Z&headache_name=Headache1&start_date=2021-01-01T18:30:00Z&user_id=4613
  getTrendsUserData(
      String startDate, String endDate, String headacheName) async {
    String apiResponse;
    var userProfileInfoData;
    if(!kIsWeb) {
      userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String userInfoJson = sharedPreferences.getString(Constant.userInfo);

      userProfileInfoData = userProfileInfoModelFromJson(userInfoJson);
    }
    try {
      String url = WebservicePost.qaServerUrl +
          'trends/event/?' +
          "start_date=" +
          startDate +
          "&" +
          "end_date=" +
          endDate +
          "&" +
          "user_id=" +
          userProfileInfoData.userId +
          "&" +
          "headache_name=" +
          headacheName;
      var response = await _recordsTrendsRepository.trendsServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        recordsTrendsDataSink.addError(response);
        networkDataSink.addError(Exception(Constant.somethingWentWrong));
        apiResponse = response.toString();
      } else {
        if (response != null) {
          List<HeadacheListDataModel> headacheDataList = [];
          if (_recordsTrendsDataModel.headacheListModelData.length > 0) {
            headacheDataList = _recordsTrendsDataModel.headacheListModelData;
          }
          _recordsTrendsDataModel = RecordsTrendsDataModel.fromJson(jsonDecode(response));
          apiResponse = Constant.success;
          _recordsTrendsDataModel.headacheListModelData = headacheDataList;
          recordsTrendsDataSink.add(_recordsTrendsDataModel);
          networkDataSink.add(Constant.success);
        } else {
          print('here 1');
          recordsTrendsDataSink.addError(Exception(Constant.somethingWentWrong));
          networkDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      print('here 2');
      recordsTrendsDataSink.addError(Exception(Constant.somethingWentWrong));
      networkDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  getMultipleHeadacheTrendsDate(String startDate, String endDate,String firstHeadacheName,String secondHeadacheName)async{
    String apiResponse;
    var userProfileInfoData;
    if(!kIsWeb) {
      userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String userInfoJson = sharedPreferences.getString(Constant.userInfo);

      userProfileInfoData = userProfileInfoModelFromJson(userInfoJson);
    }
    try {
      String url = WebservicePost.qaServerUrl +
          'trends/compare/?' +
          "start_date=" +
          startDate +
          "&" +
          "end_date=" +
          endDate +
          "&" +
          "user_id=" +
          userProfileInfoData.userId +
          "&" +
          "headache_first=" +
          firstHeadacheName
          +
          "&" +
          "headache_second=" +
          secondHeadacheName;
      var response = await _recordsTrendsRepository.trendsServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        recordsTrendsDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if (response != null) {
          List<HeadacheListDataModel> headacheDataList = [];
          if (_recordsTrendsDataModel.headacheListModelData.length > 0) {
            headacheDataList = _recordsTrendsDataModel.headacheListModelData;
          }
          _recordsTrendsDataModel.recordsTrendsMultipleHeadacheDataModel = RecordsTrendsMultipleHeadacheDataModel.fromJson(jsonDecode(response));
          apiResponse = Constant.success;
          _recordsTrendsDataModel.headacheListModelData = headacheDataList;

          _recordsTrendsDataModel.behaviors = _recordsTrendsDataModel.recordsTrendsMultipleHeadacheDataModel.behaviors;
          _recordsTrendsDataModel.medication = _recordsTrendsDataModel.recordsTrendsMultipleHeadacheDataModel.medication;
          _recordsTrendsDataModel.triggers = _recordsTrendsDataModel.recordsTrendsMultipleHeadacheDataModel.triggers;
          recordsTrendsDataSink.add(_recordsTrendsDataModel);
          networkDataSink.add(Constant.success);
        } else {
          recordsTrendsDataSink.addError(Exception(Constant.somethingWentWrong));
          networkDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      recordsTrendsDataSink.addError(Exception(Constant.somethingWentWrong));
      networkDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;

  }

  void enterSomeDummyDataToStream() {
    recordsTrendsDataSink.add(Constant.loading);
  }

  void init() {
    _recordsTrendsStreamController?.close();
    _recordsTrendsStreamController = StreamController<dynamic>();
  }

  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void dispose() {
    _recordsTrendsStreamController?.close();
  }
}
