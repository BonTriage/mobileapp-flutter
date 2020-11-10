import 'dart:async';

import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
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
      String url = WebservicePost.qaServerUrl+'user/?' +
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
        apiResponse = Constant.success;
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
