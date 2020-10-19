import 'dart:async';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/AddHeadacheLogRepository.dart';
import 'package:mobile/util/AddHeadacheLinearListFilter.dart';

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

  fetchAddHeadacheLogData() async {
    try {
      var addHeadacheLogData = await _addHeadacheLogRepository.serviceCall(
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
          RequestMethod.POST);
      if (addHeadacheLogData is AppException) {
        addHeadacheLogDataSink.add(addHeadacheLogData.toString());
      } else {
        var addHeadacheLogListData =
            AddHeadacheLinearListFilter.getQuestionSeries(
                addHeadacheLogData.questionnaires[0].initialQuestion,
                addHeadacheLogData
                    .questionnaires[0].questionGroups[0].questions);
        print(addHeadacheLogListData[0].values);
        addHeadacheLogDataSink.add(addHeadacheLogListData);
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
      print('Error');
    }
  }

  Future<List<Map>> fetchDataFromLocalDatabase(String userId) async {
    return await _addHeadacheLogRepository
        .getAllHeadacheDataFromDatabase(userId);
  }

  sendAddHeadacheDetailsData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    try {
      var signUpFirstStepData =
          await _addHeadacheLogRepository.userAddHeadacheObjectServiceCall(
              'https://mobileapi3.bontriage.com:8181/mobileapi/v0/event',
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
    _addHeadacheLogStreamController?.close();
  }
}
