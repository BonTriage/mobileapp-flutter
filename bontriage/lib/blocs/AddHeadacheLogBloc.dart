import 'dart:async';
import 'package:http/http.dart';
import 'package:mobile/models/AddHeadacheLogModel.dart';
import 'package:mobile/models/CalendarInfoDataModel.dart';
import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/models/HeadacheLogDataModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/AddHeadacheLogRepository.dart';
import 'package:mobile/util/AddHeadacheLinearListFilter.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class AddHeadacheLogBloc {
  AddHeadacheLogRepository _addHeadacheLogRepository;
  StreamController<dynamic> _addHeadacheLogStreamController;
  StreamController<dynamic> _addNoteStreamController;
  CurrentUserHeadacheModel currentUserHeadacheModel;
  int count = 0;

  List<SelectedAnswers> selectedAnswersList = [];

  int headacheId;

  StreamSink<dynamic> get addHeadacheLogDataSink =>
      _addHeadacheLogStreamController.sink;

  Stream<dynamic> get addHeadacheLogDataStream =>
      _addHeadacheLogStreamController.stream;

  StreamController<dynamic> _sendAddHeadacheLogStreamController;

  StreamSink<dynamic> get sendAddHeadacheLogDataSink =>
      _sendAddHeadacheLogStreamController.sink;

  Stream<dynamic> get sendAddHeadacheLogDataStream =>
      _sendAddHeadacheLogStreamController.stream;

  StreamSink<dynamic> get addNoteSink =>
      _addNoteStreamController.sink;

  Stream<dynamic> get addNoteStream =>
      _addNoteStreamController.stream;

  bool isHeadacheLogged = false;


  AddHeadacheLogBloc({this.count = 0}) {
    _addHeadacheLogStreamController = StreamController<dynamic>();
    _sendAddHeadacheLogStreamController = StreamController<dynamic>();
    _addNoteStreamController = StreamController<dynamic>();
    _addHeadacheLogRepository = AddHeadacheLogRepository();
  }

  fetchCalendarHeadacheLogDayData(int headacheId) async {
    this.headacheId = headacheId;
    String apiResponse;
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = '${WebservicePost.qaServerUrl}calender/$headacheId';
      var response = await _addHeadacheLogRepository.calendarTriggersServiceCall(url, RequestMethod.GET);
      if (response is AppException) {
        apiResponse = response.toString();
        addHeadacheLogDataSink.addError(response.toString());
      } else {
        if (response != null && response is List<HeadacheLogDataModel>) {
          List<HeadacheLogDataModel> headacheLogDataModelList = response;

          headacheLogDataModelList.forEach((headacheLogDataModelElement) {
            headacheLogDataModelElement.mobileEventDetails.forEach((mobileEventDetailsElement) {
              selectedAnswersList.add(SelectedAnswers(questionTag: mobileEventDetailsElement.questionTag, answer: mobileEventDetailsElement.value));
            });
          });
        }
        await fetchAddHeadacheLogData();
      }
    } catch (e) {
      apiResponse = Constant.somethingWentWrong;
      addHeadacheLogDataSink.addError(Exception(Constant.somethingWentWrong));
    }
    return apiResponse;
  }

  fetchAddHeadacheLogData() async {
    try {
      var addHeadacheLogData = await _addHeadacheLogRepository.serviceCall(WebservicePost.qaServerUrl + 'questionnaire', RequestMethod.POST);
      if (addHeadacheLogData is AppException) {
        addHeadacheLogDataSink.addError(addHeadacheLogData.toString());
      } else {
        if(addHeadacheLogData != null) {
          if(addHeadacheLogData is AddHeadacheLogModel) {
            var addHeadacheLogListData = AddHeadacheLinearListFilter
                .getQuestionSeries(
                addHeadacheLogData.questionnaires[0].initialQuestion,
                addHeadacheLogData.questionnaires[0].questionGroups[0]
                    .questions);
            print(addHeadacheLogListData[0].values);
            addHeadacheLogDataSink.add(addHeadacheLogListData);
          } else {
            addHeadacheLogDataSink.addError(Exception(Constant.somethingWentWrong));
          }
        } else {
          addHeadacheLogDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      //  signUpFirstStepDataSink.add("Error");
      addHeadacheLogDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e.toString());
    }
  }

  Future<List<Map>> fetchDataFromLocalDatabase(String userId) async {
    return await _addHeadacheLogRepository
        .getAllHeadacheDataFromDatabase(userId);
  }

  sendAddHeadacheDetailsData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel) async {
    String apiResponse;
    try {
      _addHeadacheLogRepository.currentUserHeadacheModel = currentUserHeadacheModel;
      var signUpFirstStepData;
      if(headacheId == null)
        signUpFirstStepData = await _addHeadacheLogRepository.userAddHeadacheObjectServiceCall(WebservicePost.qaServerUrl + 'event', RequestMethod.POST, signUpOnBoardSelectedAnswersModel);
      else
        signUpFirstStepData = await _addHeadacheLogRepository.userAddHeadacheObjectServiceCall(WebservicePost.qaServerUrl + 'event/$headacheId', RequestMethod.POST, signUpOnBoardSelectedAnswersModel);

      if (signUpFirstStepData is AppException) {
        sendAddHeadacheLogDataSink.addError(signUpFirstStepData);
        apiResponse = signUpFirstStepData.toString();
        //signUpFirstStepDataSink.add(signUpFirstStepData.toString());
      } else {
        if(signUpFirstStepData != null) {
          isHeadacheLogged = true;
          apiResponse = Constant.success;
        } else {
          sendAddHeadacheLogDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      sendAddHeadacheLogDataSink.addError(Exception(Constant.somethingWentWrong));
      apiResponse = Constant.somethingWentWrong;
      //  signUpFirstStepDataSink.add("Error");
    }
    return apiResponse;
  }

  void dispose() {
    _addHeadacheLogStreamController?.close();
    _sendAddHeadacheLogStreamController?.close();
    _addNoteStreamController?.close();
  }

  void addDataToNoteStream() {
    addNoteSink.add(Constant.loading);
  }

  void enterSomeDummyData() {
    sendAddHeadacheLogDataSink.add(Constant.loading);
  }
}
