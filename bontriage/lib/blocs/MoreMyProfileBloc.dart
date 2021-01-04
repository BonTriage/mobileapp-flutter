import 'dart:async';

import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/MoreMyProfileRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class MoreMyProfileBloc {

  StreamController<dynamic> _myProfileStreamController;

  Stream<dynamic> get myProfileStream => _myProfileStreamController.stream;
  StreamSink<dynamic> get myProfileSink => _myProfileStreamController.sink;

  StreamController<dynamic> _networkStreamController;

  Stream<dynamic> get networkStream => _networkStreamController.stream;
  StreamSink<dynamic> get networkSink => _networkStreamController.sink;

  MoreMyProfileRepository _moreMyProfileRepository;
  UserProfileInfoModel userProfileInfoModel;

  MoreMyProfileBloc() {
    _myProfileStreamController = StreamController<dynamic>();
    _moreMyProfileRepository = MoreMyProfileRepository();
  }

  Future<void> fetchMyProfileData() async {
    userProfileInfoModel = await _moreMyProfileRepository.getUserProfileInfoModel();

    if(userProfileInfoModel != null) {
      try {
        String url = '${WebservicePost.qaServerUrl}user?email=${userProfileInfoModel.email}';
        var response = await _moreMyProfileRepository.myProfileServiceCall(url, RequestMethod.GET);
        if (response is AppException) {
          myProfileSink.addError(response);
          networkSink.addError(response);
        } else {
          if (response != null && response is UserProfileInfoModel) {
            networkSink.add(Constant.success);
            myProfileSink.add(userProfileInfoModel);
          } else {
            myProfileSink.addError(Exception(Constant.somethingWentWrong));
            networkSink.addError(Exception(Constant.somethingWentWrong));
          }
        }
      } catch (e) {
        myProfileSink.addError(Exception(Constant.somethingWentWrong));
        networkSink.addError(Exception(Constant.somethingWentWrong));
      }
    }
  }

  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void enterSomeDummyData() {
    networkSink.add(Constant.loading);
  }

  void dispose() {
    _myProfileStreamController?.close();
    _networkStreamController?.close();
  }
}