import 'dart:async';
import 'dart:convert';
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:mobile/models/WelcomeOnBoardProfileModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/WelcomeOnBoardProfileRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';

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
              'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
              RequestMethod.POST);
      if (signUpFirstStepData is AppException) {
        signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpFirstStepDataSink.add(filterQuestionsListData);
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
    }
  }

  sendSignUpFirstStepData(SignUpOnBoardSelectedAnswersModel signUpOnBoardSelectedAnswersModel) async {
    try {
      var signUpFirstStepData =
      await _welcomeOnBoardProfileRepository.signUpProfileInfoObjectServiceCall(
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/event',
          RequestMethod.POST,signUpOnBoardSelectedAnswersModel);
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

  fetchDataFromLocalDatabase() async {
    List<LocalQuestionnaire> localQuestionnaireData =
        await SignUpOnBoardProviders.db.getQuestionnaire();
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
        json.decode(localQuestionnaireEventData.selectedAnswers));
  }


}
