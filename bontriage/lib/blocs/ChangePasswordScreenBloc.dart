import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/LoginScreenRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


  /// This method will be use for implement API for to check USer Already registered in to the application or not.
  Future<dynamic> sendChangePasswordData(
      String emailValue, String passwordValue, bool isFromMoreSettings) async {
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
        if(!isFromMoreSettings) {
          UserProfileInfoModel userProfileInfoModel = UserProfileInfoModel();
          userProfileInfoModel =
              UserProfileInfoModel.fromJson(jsonDecode(response));
          if(userProfileInfoModel.profileName == null) {
            userProfileInfoModel.profileName = userProfileInfoModel.firstName;
          }
          await _deleteAllUserData();
          await SignUpOnBoardProviders.db.deleteTableQuestionnaires();
          await SignUpOnBoardProviders.db.deleteTableUserProgress();
          await SignUpOnBoardProviders.db .insertUserProfileInfo(userProfileInfoModel);
        }
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
