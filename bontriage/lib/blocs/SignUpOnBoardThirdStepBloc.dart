import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/SignUpOnBoardThirdStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardThirdStepBloc {
  SignUpOnBoardThirdStepRepository _signUpOnBoardThirdStepRepository;
  StreamController<dynamic>
      __signUpOnBoardThirdStepRepositoryDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpOnBoardThirdStepDataSink =>
      __signUpOnBoardThirdStepRepositoryDataStreamController.sink;

  Stream<dynamic> get signUpOnBoardThirdStepDataStream =>
      __signUpOnBoardThirdStepRepositoryDataStreamController.stream;

  StreamController<dynamic>
  _sendThirdStepDataStreamController;

  StreamSink<dynamic> get sendThirdStepDataSink =>
      _sendThirdStepDataStreamController.sink;

  Stream<dynamic> get sendThirdStepDataStream =>
      _sendThirdStepDataStreamController.stream;

  SignUpOnBoardThirdStepBloc({this.count = 0}) {
    __signUpOnBoardThirdStepRepositoryDataStreamController =
        StreamController<dynamic>();
    _sendThirdStepDataStreamController = StreamController<dynamic>();
    _signUpOnBoardThirdStepRepository = SignUpOnBoardThirdStepRepository();
  }

  fetchSignUpOnBoardThirdStepData(String argumentsName) async {
    try {
      var signUpFirstStepData =
          await _signUpOnBoardThirdStepRepository.serviceCall(
              WebservicePost.qaServerUrl + 'questionnaire',
              RequestMethod.POST,
              argumentsName);
      if (signUpFirstStepData is AppException) {
        signUpOnBoardThirdStepDataSink.addError(signUpFirstStepData);
      } else {
        if(signUpFirstStepData is SignUpOnBoardSecondStepModel) {
          if(signUpFirstStepData != null) {
            var filterQuestionsListData = LinearListFilter.getQuestionSeries(
                signUpFirstStepData.questionnaires[0].initialQuestion,
                signUpFirstStepData.questionnaires[0].questionGroups[0]
                    .questions);
            print(filterQuestionsListData);
            signUpOnBoardThirdStepDataSink.add(filterQuestionsListData);
          } else {
            signUpOnBoardThirdStepDataSink.addError(Exception(Constant.somethingWentWrong));
          }
        } else {
          signUpOnBoardThirdStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      signUpOnBoardThirdStepDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e);
    }
  }

  fetchDataFromLocalDatabase(
      List<LocalQuestionnaire> localQuestionnaireData) async {
    LocalQuestionnaire localQuestionnaireEventData = localQuestionnaireData[0];
    SignUpOnBoardSecondStepModel welcomeOnBoardProfileModel =
        SignUpOnBoardSecondStepModel();
    welcomeOnBoardProfileModel = SignUpOnBoardSecondStepModel.fromJson(
        json.decode(localQuestionnaireEventData.questionnaires));
    var filterQuestionsListData = LinearListFilter.getQuestionSeries(
        welcomeOnBoardProfileModel.questionnaires[0].initialQuestion,
        welcomeOnBoardProfileModel
            .questionnaires[0].questionGroups[0].questions);
    signUpOnBoardThirdStepDataSink.add(filterQuestionsListData);

    return SignUpOnBoardSelectedAnswersModel.fromJson(
        jsonDecode(localQuestionnaireEventData.selectedAnswers));
  }

  void dispose() {
    __signUpOnBoardThirdStepRepositoryDataStreamController?.close();
    _sendThirdStepDataStreamController?.close();
  }

  sendSignUpThirdStepData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    String apiResponse;
    try {
      var signUpThirdStepData = await _signUpOnBoardThirdStepRepository
          .signUpThirdStepInfoObjectServiceCall(
              WebservicePost.qaServerUrl + 'event',
              RequestMethod.POST,
              signUpOnBoardSelectedAnswersModel);
      if (signUpThirdStepData is AppException) {
        print(signUpThirdStepData);
        sendThirdStepDataSink.addError(signUpThirdStepData);
        apiResponse = signUpThirdStepData.toString();
      } else {
        print(signUpThirdStepData);
        if(signUpThirdStepData != null) {
          apiResponse = Constant.success;
        } else {
          sendThirdStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      sendThirdStepDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
    }
    return apiResponse;
  }

  void enterSomeDummyDataToStreamController() {
    sendThirdStepDataSink.add(Constant.loading);
  }
}
