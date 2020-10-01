import 'dart:async';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/SignUpOnBoardSecondStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';

class SignUpOnBoardSecondStepBloc {
  SignUpOnBoardFirstStepRepository _signUpOnBoardFirstStepRepository;
  StreamController<dynamic> __signUpOnBoardSecondStepRepositoryDataStreamController;
  int count = 0;

  StreamSink<dynamic> get signUpOnBoardSecondStepDataSink =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.sink;

  Stream<dynamic> get signUpOnBoardSecondStepDataStream =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.stream;

  SignUpOnBoardSecondStepBloc({this.count = 0}) {
    __signUpOnBoardSecondStepRepositoryDataStreamController = StreamController<dynamic>();
    _signUpOnBoardFirstStepRepository = SignUpOnBoardFirstStepRepository();
  }

  fetchSignUpOnBoardSecondStepData() async {
    try {
      var signUpFirstStepData =
      await _signUpOnBoardFirstStepRepository.serviceCall(
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
          RequestMethod.POST);
      if (signUpFirstStepData is AppException) {
        signUpOnBoardSecondStepDataSink.add(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        signUpOnBoardSecondStepDataSink.add(filterQuestionsListData);
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
    }
  }

  void dispose() {
    __signUpOnBoardSecondStepRepositoryDataStreamController?.close();
  }
}
