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
  StreamController<dynamic> _loginStreamController;
  int count = 0;

  StreamSink<dynamic> get loginDataSink => _loginStreamController.sink;

  Stream<dynamic> get loginDataStream => _loginStreamController.stream;

  LoginScreenBloc({this.count = 0}) {
    _loginStreamController = StreamController<dynamic>();
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
        loginDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if(response != null) {
          if (jsonDecode(response)[Constant.messageTextKey] != null) {
            String messageValue = jsonDecode(response)[Constant.messageTextKey];
            if (messageValue != null) {
              if (messageValue == Constant.userNotFound) {
                apiResponse = Constant.userNotFound;
              } else {
                apiResponse = Constant.success;
              }
            }
          } else {
            UserProfileInfoModel userProfileInfoModel =
            UserProfileInfoModel();
            userProfileInfoModel =
                UserProfileInfoModel.fromJson(jsonDecode(response));
            var selectedAnswerListData = await SignUpOnBoardProviders.db
                .insertUserProfileInfo(userProfileInfoModel);
            print(selectedAnswerListData);
            apiResponse = Constant.success;
          }
        } else {
          loginDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      loginDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  void enterSomeDummyDataToStream() {
    loginDataSink.add(Constant.loading);
  }

  void init() {
    _loginStreamController?.close();
    _loginStreamController = StreamController<dynamic>();
  }

  void dispose() {
    _loginStreamController?.close();
  }
}
