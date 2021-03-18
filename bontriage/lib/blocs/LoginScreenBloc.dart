import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/ForgotPasswordModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/LoginScreenRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/util/constant.dart';

class LoginScreenBloc {
  LoginScreenRepository _loginScreenRepository;
  StreamController<dynamic> _loginStreamController;
  int count = 0;

  StreamSink<dynamic> get loginDataSink => _loginStreamController.sink;

  Stream<dynamic> get loginDataStream => _loginStreamController.stream;

  StreamController<dynamic> _forgotPasswordStreamController;

  StreamSink<dynamic> get forgotPasswordStreamSink =>
      _forgotPasswordStreamController.sink;

  Stream<dynamic> get forgotPasswordStream =>
      _forgotPasswordStreamController.stream;

  StreamController<dynamic> _networkStreamController;

  StreamSink<dynamic> get networkStreamSink =>
      _networkStreamController.sink;

  Stream<dynamic> get networkStream =>
      _networkStreamController.stream;

  LoginScreenBloc({this.count = 0}) {
    _loginStreamController = StreamController<dynamic>();
    _forgotPasswordStreamController = StreamController<dynamic>();
    _networkStreamController = StreamController<dynamic>();
    _loginScreenRepository = LoginScreenRepository();
  }

  Future<void> callForgotPasswordApi(String userEmail) async {
    try {
      String url = '${WebservicePost.qaServerUrl}otp?email=$userEmail';
      var response = await _loginScreenRepository.forgotPasswordServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        forgotPasswordStreamSink.addError(response);
        networkStreamSink.addError(response);
      } else {
        if (response != null && response is ForgotPasswordModel) {
          networkStreamSink.add(Constant.success);
          forgotPasswordStreamSink.add(response);
        } else {
          networkStreamSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      networkStreamSink.addError(Exception(Constant.somethingWentWrong));
    }
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
      var response = await _loginScreenRepository.loginServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        loginDataSink.addError(response);
        apiResponse = response.toString();
      } else {
        if (response != null) {
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
            UserProfileInfoModel userProfileInfoModel = UserProfileInfoModel();
            userProfileInfoModel =
                UserProfileInfoModel.fromJson(jsonDecode(response));
            await _deleteAllUserData();
            await SignUpOnBoardProviders.db.deleteTableQuestionnaires();
            await SignUpOnBoardProviders.db.deleteTableUserProgress();
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

  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void dispose() {
    _loginStreamController?.close();
    _forgotPasswordStreamController?.close();
    _networkStreamController?.close();
  }

  void enterDummyDataToNetworkStream() {
    networkStreamSink.add(Constant.loading);
  }

  ///This method is used to log out from the app and redirecting to the welcome start assessment screen
  Future<void> _deleteAllUserData() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      bool isVolume = sharedPreferences.getBool(Constant.chatBubbleVolumeState);
      sharedPreferences.clear();
      sharedPreferences.setBool(Constant.chatBubbleVolumeState, isVolume ?? false);
      sharedPreferences.setBool(Constant.tutorialsState, true);
      await SignUpOnBoardProviders.db.deleteAllTableData();
    } catch (e) {
      print(e);
    }
  }
}
