import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/ForgotPasswordModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/OtpValidationRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class OtpValidationBloc {
  StreamController<int> _otpTimerStreamController;

  StreamSink<int> get otpTimerStreamSink =>
      _otpTimerStreamController.sink;

  Stream<int> get otpTimerStream =>
      _otpTimerStreamController.stream;

  StreamController<dynamic> _otpVerifyStreamController;

  StreamSink<dynamic> get otpVerifyStreamSink =>
      _otpVerifyStreamController.sink;

  Stream<dynamic> get otpVerifyStream =>
      _otpVerifyStreamController.stream;

  StreamController<dynamic> _networkStreamController;

  StreamSink<dynamic> get networkStreamSink =>
      _networkStreamController.sink;

  Stream<dynamic> get networkStream =>
      _networkStreamController.stream;

  OtpValidationRepository _repository;


  OtpValidationBloc() {
    _repository = OtpValidationRepository();

    _otpTimerStreamController = StreamController<int>();
    _otpVerifyStreamController = StreamController<dynamic>();

    _networkStreamController = StreamController<dynamic>();
  }

  Future<void> callOtpVerifyApi(String userEmail, String otp, bool isFromSignUp, String password, bool isTermConditionCheck, bool isEmailMarkCheck,) async {
    try {
      String url = '${WebservicePost.qaServerUrl}otp/validate?email=$userEmail&otp=$otp';
      var response = await _repository.otpVerifyServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        otpVerifyStreamSink.addError(response);
        networkStreamSink.addError(response);
      } else {
        if (response != null && response is ForgotPasswordModel) {

          if(isFromSignUp && response.status == 1)
            await signUpOfNewUser(userEmail, password, isTermConditionCheck, isEmailMarkCheck, response);
          else {
            networkStreamSink.add(Constant.success);
            otpVerifyStreamSink.add(response);
          }
        } else {
          networkStreamSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      networkStreamSink.addError(Exception(Constant.somethingWentWrong));
    }
  }

  Future<void> callResendOTPApi(String userEmail) async {
    try {
      String url = '${WebservicePost.qaServerUrl}otp?email=$userEmail&isUserExist=false';
      var response = await _repository.otpVerifyServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        print(response);
      } else {
        if (response != null && response is ForgotPasswordModel) {
          print(Constant.success);
        } else {
          print(Constant.somethingWentWrong);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> signUpOfNewUser(String emailValue, String passwordValue, bool isTermConditionCheck, bool isEmailMarkCheck, ForgotPasswordModel forgotPasswordModel) async {
    String apiResponse;
    UserProfileInfoModel userProfileInfoModel;
    List<SelectedAnswers> selectedAnswerListData = await SignUpOnBoardProviders.db.getAllSelectedAnswers(Constant.zeroEventStep);
    try {
      var response = await _repository.signUpServiceCall(
          WebservicePost.qaServerUrl + "user/",
          RequestMethod.POST,
          selectedAnswerListData,
          emailValue,
          passwordValue,
          isTermConditionCheck,
          isEmailMarkCheck
      );
      if (response is AppException) {
        apiResponse = response.toString();
        networkStreamSink.addError(response);
      } else {
        apiResponse = Constant.success;
        userProfileInfoModel = UserProfileInfoModel.fromJson(jsonDecode(response));
        userProfileInfoModel.profileName = userProfileInfoModel.firstName;
        await SignUpOnBoardProviders.db.insertUserProfileInfo(userProfileInfoModel);
        networkStreamSink.add(Constant.success);
        otpVerifyStreamSink.add(forgotPasswordModel);
      }
    } catch (e) {
      networkStreamSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  String getFormattedTime(int seconds) {
    int remainingSeconds = 30 - seconds;
    String formattedTime = '0:30';

    int minutes = remainingSeconds ~/ 60;
    int second = remainingSeconds % 60;

    if(second < 10)
      formattedTime = '$minutes:0$second';
    else
      formattedTime = '$minutes:$second';

    return formattedTime;
  }

  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void enterDummyDataToNetworkStream() {
    networkStreamSink.add(Constant.loading);
  }

  void dispose() {
    _otpTimerStreamController?.close();
    _networkStreamController?.close();
    _otpVerifyStreamController?.close();
  }
}