import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/SignUpScreenOnBoardModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';

class SignUpScreenRepository {
  String url;

  Future<dynamic> serviceCall(String url, RequestMethod requestMethod) async {
    var client = http.Client();
    var album;
    try {
      var response = await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return response;
      }
    } catch (Exception) {
      return album;
    }
  }

  Future<dynamic> signUpServiceCall(String url, RequestMethod requestMethod,
      List<SelectedAnswers> selectedAnswerListData, String emailValue, String passwordValue) async {
    var client = http.Client();
    var album;
    try {
      var response = await NetworkService(
              url, requestMethod, _setUserSignUpPayload(selectedAnswerListData,emailValue,passwordValue))
          .serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return response;
      }
    } catch (Exception) {
      return album;
    }
  }

  String _setUserSignUpPayload(List<SelectedAnswers> selectedAnswers, String emailValue, String passwordValue) {
    SignUpScreenOnBoardModel signUpScreenOnBoardModel =
        SignUpScreenOnBoardModel();

    SelectedAnswers ageValue = selectedAnswers
        .firstWhere((model) => model.questionTag == "profile.age");
    SelectedAnswers genderValue = selectedAnswers
        .firstWhere((model) => model.questionTag == "profile.sex");
    SelectedAnswers nameValue = selectedAnswers
        .firstWhere((model) => model.questionTag == "profile.firstname");

    signUpScreenOnBoardModel.email = emailValue;
    signUpScreenOnBoardModel.age = ageValue.answer;
    signUpScreenOnBoardModel.firstName = nameValue.answer;
    signUpScreenOnBoardModel.lastName = "";
    signUpScreenOnBoardModel.location = "";
    signUpScreenOnBoardModel.notificationKey = "";
    signUpScreenOnBoardModel.password = passwordValue;
    signUpScreenOnBoardModel.sex = genderValue.answer;

    return jsonEncode(signUpScreenOnBoardModel);
  }
}