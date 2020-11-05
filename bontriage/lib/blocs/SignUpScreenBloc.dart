import 'dart:async';

import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
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

  Future<dynamic> signUpOfNewUser(List<SelectedAnswers> selectedAnswerListData) async {
    try {
      var album =
      await _signUpScreenRepository.signUpServiceCall("https://mobileapi3.bontriage.com:8181/mobileapi/v0/user/", RequestMethod.POST,selectedAnswerListData);
      if (album is AppException) {
        albumDataSink.add(album.toString());
      } else {
        return album;
      }
    } catch (Exception) {
      albumDataSink.add("Error");
    }
  }

  void dispose() {
    _albumStreamController?.close();
  }
}
