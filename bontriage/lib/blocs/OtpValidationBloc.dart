import 'dart:async';

import 'package:mobile/models/ForgotPasswordModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
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

  Future<void> callOtpVerifyApi(String userEmail, String otp) async {
    try {
      String url = '${WebservicePost.qaServerUrl}otp/validate?email=$userEmail&otp=$otp';
      var response = await _repository.otpVerifyServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        otpVerifyStreamSink.addError(response);
        networkStreamSink.addError(response);
      } else {
        if (response != null && response is ForgotPasswordModel) {
          networkStreamSink.add(Constant.success);
          otpVerifyStreamSink.add(response);
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
      String url = '${WebservicePost.qaServerUrl}otp?email=$userEmail';
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