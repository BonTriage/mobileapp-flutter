import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/LoginScreenRepository.dart';
import 'package:mobile/repository/SignUpScreenRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class ChangePasswordBloc {
  LoginScreenRepository _loginScreenRepository;
  StreamController<String> _changePasswordStreamController;
  int count = 0;

  StreamSink<String> get changePasswordScreenDataSink =>
      _changePasswordStreamController.sink;

  Stream<String> get changePasswordDataStream =>
      _changePasswordStreamController.stream;

  StreamController<dynamic> _changePasswordScreenStreamController;

  ChangePasswordBloc({this.count = 0}) {
    _changePasswordStreamController = StreamController<String>();

    _changePasswordScreenStreamController = StreamController<dynamic>();
    _loginScreenRepository = LoginScreenRepository();
  }

//http://34.222.200.187:8080/mobileapi/v0/user/changepassword?email=rahul.haldhar@gmail.com&password=password
  //http://34.222.200.187:8080/mobileapi/v0/user/changepassword?email=test261@yopmail.com&password=123456Abc
  /// This method will be use for implement API for to check USer Already registered in to the application or not.
  Future<dynamic> sendChangePasswordData(
      String emailValue, String passwordValue) async {
    String apiResponse;
    try {
      String url = WebservicePost.qaServerUrl +
          'user/changepassword?' +
          "email=" +
          emailValue +
          "&" +
          "password=" +
          passwordValue;
      var response =
          await _loginScreenRepository.loginServiceCall(url, RequestMethod.POST);
      if (response is AppException) {
        changePasswordScreenDataSink.addError(response);
        apiResponse = response.toString();
        print(apiResponse.toString());
      } else {
        apiResponse = Constant.success;
        changePasswordScreenDataSink.add(Constant.success);
      }
    } catch (e) {
      changePasswordScreenDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e.toString());
    }
    return apiResponse;
  }

  void enterSomeDummyDataToStreamController() {
    changePasswordScreenDataSink.add(Constant.loading);
  }

  void dispose() {
    _changePasswordStreamController?.close();
    _changePasswordScreenStreamController?.close();
  }

  void inItNetworkStream() {
    _changePasswordScreenStreamController?.close();
    _changePasswordScreenStreamController = StreamController<dynamic>();
  }
}
