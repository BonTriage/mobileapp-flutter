import 'dart:async';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/AddHeadacheLogRepository.dart';
import 'package:mobile/util/AddHeadacheLinearListFilter.dart';
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

  fetchAddHeadacheLogData() async {
    try {
      var addHeadacheLogData =
      await _addHeadacheLogRepository.serviceCall(
          'https://mobileapi3.bontriage.com:8181/mobileapi/v0/questionnaire',
          RequestMethod.POST);
      if (addHeadacheLogData is AppException) {
        addHeadacheLogDataSink.add(addHeadacheLogData.toString());
      } else {
        var addHeadacheLogListData = AddHeadacheLinearListFilter.getQuestionSeries(
            addHeadacheLogData.questionnaires[0].initialQuestion,
            addHeadacheLogData.questionnaires[0].questionGroups[0].questions);
        print(addHeadacheLogListData[0].values);
        addHeadacheLogDataSink.add(addHeadacheLogListData);
      }
    } catch (Exception) {
      //  signUpFirstStepDataSink.add("Error");
      print('Error');
    }
  }

  void dispose() {
    _addHeadacheLogStreamController?.close();
  }
}
