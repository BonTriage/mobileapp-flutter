import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/LoginScreenRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class LoginScreenBloc {
  LoginScreenRepository _loginScreenRepository;
  StreamController<String> _albumStreamController;
  int count = 0;

  StreamSink<String> get albumDataSink => _albumStreamController.sink;

  Stream<String> get albumDataStream => _albumStreamController.stream;

  LoginScreenBloc({this.count = 0}) {
    _albumStreamController = StreamController<String>();
    _loginScreenRepository = LoginScreenRepository();
  }

  getLoginOfUser(String emailValue, String passwordValue) async {
    String apiResponse;
    try {
      String url = WebservicePost.qaServerUrl +
          'user/?' +
          "email=" +
          emailValue +
          "&" +
          "password=" +
          passwordValue;
      var response =
          await _loginScreenRepository.loginServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        apiResponse = response.toString();
      } else {
        if (jsonDecode(response)[Constant.messageTextKey] != null) {
          String messageValue = jsonDecode(response)[Constant.messageTextKey];
          if (messageValue != null) {
            if (messageValue == Constant.userNotFound) {
              apiResponse = Constant.somethingWentWrong;
            } else {
              apiResponse = Constant.success;
            }
          }
        }else{
          UserProfileInfoModel userProfileInfoModel =
          UserProfileInfoModel();
          userProfileInfoModel =
              UserProfileInfoModel.fromJson(jsonDecode(response));
          var selectedAnswerListData = await SignUpOnBoardProviders.db
              .insertUserProfileInfo(userProfileInfoModel);
          print(selectedAnswerListData);
          apiResponse = Constant.success;
        }
      }
    } catch (Exception) {
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  void dispose() {
    _albumStreamController?.close();
  }
}
