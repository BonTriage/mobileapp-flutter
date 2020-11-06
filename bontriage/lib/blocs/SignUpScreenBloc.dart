import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/SignUpScreenRepository.dart';

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
      String url = 'https://mobileapi3.bontriage.com:8181/mobileapi/v0/user/?' +
          "email=" +
          emailValue +
          "&" +
          "check_user_exists=1";
      var album =
          await _signUpScreenRepository.serviceCall(url, RequestMethod.GET);
      if (album is AppException) {
        albumDataSink.add(album.toString());
      } else {
        return album;
      }
    } catch (Exception) {
      albumDataSink.add("Error");
    }
  }

  /// This method will be use for implement API for SignUp into the app.
  Future<dynamic> signUpOfNewUser(List<SelectedAnswers> selectedAnswerListData,
      String emailValue, String passwordValue) async {
    bool apiResponse;
    UserProfileInfoModel userProfileInfoModel;
    try {
      var response = await _signUpScreenRepository.signUpServiceCall(
          "https://mobileapi3.bontriage.com:8181/mobileapi/v0/user/",
          RequestMethod.POST,
          selectedAnswerListData,
          emailValue,
          passwordValue);
      if (response is AppException) {
        apiResponse = false;
      } else {
        apiResponse = true;
        userProfileInfoModel =
            UserProfileInfoModel.fromJson(jsonDecode(response));
        var loggedInUserInformationData = await SignUpOnBoardProviders.db
            .insertUserProfileInfo(userProfileInfoModel);
        print(loggedInUserInformationData);
      }
    } catch (Exception) {
      apiResponse = false;
    }
    return apiResponse;
  }

  void dispose() {
    _albumStreamController?.close();
  }
}
