import 'dart:async';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/AddHeadacheLogRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';

class AddHeadacheLogBloc {
  AddHeadacheLogRepository _addHeadacheLogRepository;
  StreamController<dynamic> _addHeadacheLogStreamController;
  int count = 0;

  StreamSink<dynamic> get addHeadacheLogDataSink =>
      _addHeadacheLogStreamController.sink;

  Stream<dynamic> get addHeadacheLogDataStream =>
      _addHeadacheLogStreamController.stream;

  AddHeadacheLogBloc({this.count = 0}) {
    _addHeadacheLogStreamController = StreamController<dynamic>();
    _addHeadacheLogRepository = AddHeadacheLogRepository();
  }

  fetchSignUpFirstStepData() async {
    try {
      var signUpFirstStepData =
      await _addHeadacheLogRepository.serviceCall(
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
          RequestMethod.POST);
      if (signUpFirstStepData is AppException) {
        addHeadacheLogDataSink.add(signUpFirstStepData.toString());
      } else {
        var filterQuestionsListData = LinearListFilter.getQuestionSeries(
            signUpFirstStepData.questionnaires[0].initialQuestion,
            signUpFirstStepData.questionnaires[0].questionGroups[0].questions);
        print(filterQuestionsListData);
        addHeadacheLogDataSink.add(filterQuestionsListData);
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
    }
  }

  void dispose() {
    _addHeadacheLogStreamController?.close();
  }
}
