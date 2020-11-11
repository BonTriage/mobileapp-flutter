import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/SignUpScreenRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class SignUpScreenBloc {
  SignUpScreenRepository _signUpScreenRepository;
  StreamController<String> _albumStreamController;
  int count = 0;

  StreamSink<String> get albumDataSink => _albumStreamController.sink;

  Stream<String> get albumDataStream => _albumStreamController.stream;

  SignUpScreenBloc({this.count = 0}) {
    _albumStreamController = StreamController<String>();
    _signUpScreenRepository = SignUpScreenRepository();
  }

  /// This method will be use for implement API for to check USer Already registered in to the application or not.
  Future<dynamic> checkUserAlreadyExistsOrNot(String emailValue) async {
    try {
      String url = WebservicePost.qaServerUrl +
          'user/?' +
          "email=" +
          emailValue +
          "&" +
          "check_user_exists=1";
      var apiResponse = await _signUpScreenRepository.serviceCall(url, RequestMethod.GET);
      if (apiResponse is AppException) {
        //albumDataSink.add(apiResponse.toString());
        print(apiResponse.toString());
      } else {
        return apiResponse;
      }
    } catch (e) {
      //albumDataSink.add("Error");
      print(e.toString());
    }
  }

  /// This method will be use for implement API for SignUp into the app.
  Future<dynamic> signUpOfNewUser(List<SelectedAnswers> selectedAnswerListData,
      String emailValue, String passwordValue) async {
    String apiResponse;
    UserProfileInfoModel userProfileInfoModel;
    try {
      var response = await _signUpScreenRepository.signUpServiceCall(
          WebservicePost.qaServerUrl + "user/",
          RequestMethod.POST,
          selectedAnswerListData,
          emailValue,
          passwordValue);
      if (response is AppException) {
        apiResponse = response.toString();
      } else {
        apiResponse = Constant.success;
        userProfileInfoModel = UserProfileInfoModel.fromJson(jsonDecode(response));
        var loggedInUserInformationData = await SignUpOnBoardProviders.db.insertUserProfileInfo(userProfileInfoModel);
        print(loggedInUserInformationData);
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
