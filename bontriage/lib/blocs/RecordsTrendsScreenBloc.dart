import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/RecordsTrendsDataModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/RecordsTrendsRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class RecordsTrendsScreenBloc {
  RecordsTrendsRepository _recordsTrendsRepository;
  StreamController<dynamic> _recordsTrendsStreamController;
  StreamController <dynamic> _networkStreamController;
  RecordsTrendsDataModel _recordsTrendsDataModel = RecordsTrendsDataModel();
  int count = 0;

  StreamSink<dynamic> get recordsTrendsDataSink => _recordsTrendsStreamController.sink;

  Stream<dynamic> get recordsTrendsDataStream => _recordsTrendsStreamController.stream;

  Stream<dynamic> get networkDataStream => _networkStreamController.stream;

  StreamSink<dynamic> get networkDataSink => _networkStreamController.sink;

  RecordsTrendsScreenBloc({this.count = 0}) {
    _recordsTrendsStreamController = StreamController<dynamic>();
    _recordsTrendsRepository = RecordsTrendsRepository();
    _networkStreamController = StreamController<dynamic>();
  }

  fetchAllHeadacheListData(String startDate, String endDate, String headacheName) async {
    String apiResponse;
    var userProfileInfoData =
    await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'common/fetchheadaches/' +
          /*userProfileInfoData.userId*/'4613';
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
            _recordsTrendsDataModel.headacheListModelData = headacheListModelData;
              if (headacheName != null) {
                getTrendsUserData(
                    startDate, endDate, headacheName);
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
          recordsTrendsDataSink
              .addError(Exception(Constant.somethingWentWrong));
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
  getTrendsUserData(String startDate, String endDate,String headacheName) async {
    String apiResponse;
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'trends/event/?' +
          "start_date=" +
          startDate +
          "&" +
          "end_date=" +
          endDate + "&" +
          "user_id=" +
          '4613' + "&" +
          "headache_name=" +
          headacheName;
      var response =  await _recordsTrendsRepository.trendsServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        recordsTrendsDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if (response != null) {
          _recordsTrendsDataModel =  RecordsTrendsDataModel.fromJson(jsonDecode(response));
            apiResponse = Constant.success;
            recordsTrendsDataSink.add(_recordsTrendsDataModel);

        } else {
          recordsTrendsDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      recordsTrendsDataSink.addError(Exception(Constant.somethingWentWrong));
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
