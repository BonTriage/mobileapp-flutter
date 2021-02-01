import 'dart:async';
import 'dart:convert';
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/WelcomeOnBoardProfileModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/SignUpOnBoardFirstStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class SignUpBoardFirstStepBloc {
  SignUpOnBoardFirstStepRepository _signUpOnBoardFirstStepRepository;
  StreamController<dynamic> _signUpFirstStepDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpFirstStepDataSink =>
      _signUpFirstStepDataStreamController.sink;

  Stream<dynamic> get albumDataStream =>
      _signUpFirstStepDataStreamController.stream;

  StreamController<dynamic> _sendFirstStepDataStreamController;

  StreamSink<dynamic> get sendFirstStepDataSink =>
      _sendFirstStepDataStreamController.sink;

  Stream<dynamic> get sendFirstStepDataStream =>
      _sendFirstStepDataStreamController.stream;

  SignUpBoardFirstStepBloc({this.count = 0}) {
    _signUpFirstStepDataStreamController = StreamController<dynamic>();
    _sendFirstStepDataStreamController = StreamController<dynamic>();
    _signUpOnBoardFirstStepRepository = SignUpOnBoardFirstStepRepository();
  }

// QA Url it will be change.
  fetchSignUpFirstStepData() async {
    try {
      var signUpFirstStepData =
          await _signUpOnBoardFirstStepRepository.serviceCall(
              WebservicePost.qaServerUrl + 'questionnaire', RequestMethod.POST);
      if (signUpFirstStepData is AppException) {
        signUpFirstStepDataSink.addError(signUpFirstStepData);
      } else {
        if(signUpFirstStepData is WelcomeOnBoardProfileModel) {
          if(signUpFirstStepData != null) {
            var filterQuestionsListData = LinearListFilter.getQuestionSeries(
                signUpFirstStepData.questionnaires[0].initialQuestion,
                signUpFirstStepData.questionnaires[0].questionGroups[0]
                    .questions);
            print(filterQuestionsListData);
            signUpFirstStepDataSink.add(filterQuestionsListData);
          } else {
            signUpFirstStepDataSink.addError(Exception(Constant.somethingWentWrong));
          }
        } else {
          signUpFirstStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      signUpFirstStepDataSink.addError(Exception(Constant.somethingWentWrong));
      //  signUpFirstStepDataSink.add("Error");
    }
  }

  void enterSomeDummyDataToStreamController() {
    sendFirstStepDataSink.add(Constant.loading);
  }

  sendSignUpFirstStepData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel, SignUpOnBoardSelectedAnswersModel profileOnBoardSelectedAnswersModel) async {
    String apiResponse;
    try {
      var signUpFirstStepData = await _signUpOnBoardFirstStepRepository
          .signUpZeroStepInfoObjectServiceCall(
              WebservicePost.qaServerUrl + 'event',
              RequestMethod.POST,
              profileOnBoardSelectedAnswersModel);
      if (signUpFirstStepData is AppException) {
        sendFirstStepDataSink.addError(signUpFirstStepData);
        apiResponse = signUpFirstStepData.toString();
        //signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        if(signUpFirstStepData != null) {
          //apiResponse = Constant.success;
          return await sendSignUpFirstStepData1(signUpOnBoardSelectedAnswersModel);
        } else {
          sendFirstStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      sendFirstStepDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  sendSignUpFirstStepData1(
      SignUpOnBoardSelectedAnswersModel
      signUpOnBoardSelectedAnswersModel) async {
    String apiResponse;
    try {
      var signUpFirstStepData = await _signUpOnBoardFirstStepRepository
          .signUpFirstStepInfoObjectServiceCall(
          WebservicePost.qaServerUrl + 'event',
          RequestMethod.POST,
          signUpOnBoardSelectedAnswersModel);
      if (signUpFirstStepData is AppException) {
        sendFirstStepDataSink.addError(signUpFirstStepData);
        apiResponse = signUpFirstStepData.toString();
        //signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        if(signUpFirstStepData != null) {
          apiResponse = Constant.success;
        } else {
          sendFirstStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      sendFirstStepDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  void dispose() {
    _signUpFirstStepDataStreamController?.close();
    _sendFirstStepDataStreamController?.close();
  }

  fetchDataFromLocalDatabase(
      List<LocalQuestionnaire> localQuestionnaireData) async {
    LocalQuestionnaire localQuestionnaireEventData = localQuestionnaireData[0];
    WelcomeOnBoardProfileModel welcomeOnBoardProfileModel =
        WelcomeOnBoardProfileModel();
    welcomeOnBoardProfileModel = WelcomeOnBoardProfileModel.fromJson(
        json.decode(localQuestionnaireEventData.questionnaires));
    var filterQuestionsListData = LinearListFilter.getQuestionSeries(
        welcomeOnBoardProfileModel.questionnaires[0].initialQuestion,
        welcomeOnBoardProfileModel
            .questionnaires[0].questionGroups[0].questions);
    signUpFirstStepDataSink.add(filterQuestionsListData);

    return SignUpOnBoardSelectedAnswersModel.fromJson(
        jsonDecode(localQuestionnaireEventData.selectedAnswers));
  }
}
