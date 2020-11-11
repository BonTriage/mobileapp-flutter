import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/WelcomeOnBoardProfileModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/WelcomeOnBoardProfileRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';
import 'package:mobile/util/WebservicePost.dart';

class WelcomeOnBoardProfileBloc {
  WelcomeOnBoardProfileRepository _welcomeOnBoardProfileRepository;
  StreamController<dynamic> _signUpFirstStepDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpFirstStepDataSink =>
      _signUpFirstStepDataStreamController.sink;

  Stream<dynamic> get albumDataStream =>
      _signUpFirstStepDataStreamController.stream;

  WelcomeOnBoardProfileBloc({this.count = 0}) {
    _signUpFirstStepDataStreamController = StreamController<dynamic>();
    _welcomeOnBoardProfileRepository = WelcomeOnBoardProfileRepository();
  }

  fetchSignUpFirstStepData() async {
    try {
      var signUpFirstStepData =
          await _welcomeOnBoardProfileRepository.serviceCall(
              WebservicePost.qaServerUrl + 'questionnaire', RequestMethod.POST);
      if (signUpFirstStepData is AppException) {
        signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpFirstStepDataSink.add(filterQuestionsListData);
      }
    } catch (e) {
      //  signUpFirstStepDataSink.add("Error");
      print(e.toString());
    }
  }

  sendSignUpFirstStepData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    try {
      var signUpFirstStepData = await _welcomeOnBoardProfileRepository
          .signUpProfileInfoObjectServiceCall(
              WebservicePost.qaServerUrl + 'event',
              RequestMethod.POST,
              signUpOnBoardSelectedAnswersModel);
      if (signUpFirstStepData is AppException) {
        //signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        /*   var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpFirstStepDataSink.add(filterQuestionsListData);*/
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
    }
  }

  void dispose() {
    _signUpFirstStepDataStreamController?.close();
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
