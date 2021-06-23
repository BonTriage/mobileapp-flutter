import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/SignUpOnBoardSecondStepRepository.dart';
import 'package:mobile/util/LinearListFilter.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardSecondStepBloc {
  SignUpOnBoardFirstStepRepository _signUpOnBoardFirstStepRepository;
  StreamController<dynamic>
      __signUpOnBoardSecondStepRepositoryDataStreamController;
  int count = 0;

  String eventId;

  StreamSink<dynamic> get signUpOnBoardSecondStepDataSink =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.sink;

  Stream<dynamic> get signUpOnBoardSecondStepDataStream =>
      __signUpOnBoardSecondStepRepositoryDataStreamController.stream;

  StreamController<dynamic> _sendSecondStepDataStreamController;

  StreamSink<dynamic> get sendSecondStepDataSink =>
      _sendSecondStepDataStreamController.sink;

  Stream<dynamic> get sendSecondStepDataStream =>
      _sendSecondStepDataStreamController.stream;

  List<HeadacheListDataModel> headacheListModelData = [];
  bool _isHeadacheFetched = false;

  SignUpOnBoardSecondStepBloc({this.count = 0}) {
    __signUpOnBoardSecondStepRepositoryDataStreamController =
        StreamController<dynamic>.broadcast();
    _sendSecondStepDataStreamController = StreamController<dynamic>();
    _signUpOnBoardFirstStepRepository = SignUpOnBoardFirstStepRepository();
  }

  fetchAllHeadacheListData(String argumentsName, bool isCallFetchQuestionnaire) async {
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
    try {
      String url = WebservicePost.qaServerUrl +
          'common/fetchheadaches/' +
          userProfileInfoData.userId;
      var response = await _signUpOnBoardFirstStepRepository.fetchHeadachesServiceCall(
          url, RequestMethod.GET);
      if (response is AppException) {
        signUpOnBoardSecondStepDataSink.addError(response);
      } else {
        if (response != null) {
          _isHeadacheFetched = true;
          var json = jsonDecode(response);
          //List<HeadacheListDataModel> headacheListModelData = [];
          json.forEach((v) {
            headacheListModelData.add(HeadacheListDataModel.fromJson(v));
          });

          if(isCallFetchQuestionnaire)
            await fetchSignUpOnBoardSecondStepData(argumentsName);
        } else {
          signUpOnBoardSecondStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      signUpOnBoardSecondStepDataSink.addError(Exception(Constant.somethingWentWrong));
    }
  }

  fetchSignUpOnBoardSecondStepData(String argumentsName) async {
    try {
      var signUpSecondStepData = await _signUpOnBoardFirstStepRepository.serviceCall(WebservicePost.qaServerUrl + 'questionnaire',RequestMethod.POST,argumentsName);
      if (signUpSecondStepData is AppException) {
        print(signUpSecondStepData.toString());
        signUpOnBoardSecondStepDataSink.addError(signUpSecondStepData);
      } else {
        if(signUpSecondStepData is SignUpOnBoardSecondStepModel) {
          if(signUpSecondStepData != null) {
            var filterQuestionsListData = LinearListFilter.getQuestionSeries(
                signUpSecondStepData.questionnaires[0].initialQuestion,
                signUpSecondStepData.questionnaires[0].questionGroups[0].questions);
            print(filterQuestionsListData);
            signUpOnBoardSecondStepDataSink.add(filterQuestionsListData);
          } else {
            signUpOnBoardSecondStepDataSink.addError(Exception(Constant.somethingWentWrong));
          }
        } else {
          signUpOnBoardSecondStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      signUpOnBoardSecondStepDataSink.addError(Exception(Constant.somethingWentWrong));
      print(e.toString());
      //  signUpFirstStepDataSink.add("Error");
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
        welcomeOnBoardProfileModel.questionnaires[0].questionGroups[0].questions);
    signUpOnBoardSecondStepDataSink.add(filterQuestionsListData);

    return SignUpOnBoardSelectedAnswersModel.fromJson(
        jsonDecode(localQuestionnaireEventData.selectedAnswers));
  }

  void dispose() {
    __signUpOnBoardSecondStepRepositoryDataStreamController?.close();
    _sendSecondStepDataStreamController?.close();
  }

  sendSignUpSecondStepData(
      SignUpOnBoardSelectedAnswersModel
          signUpOnBoardSelectedAnswersModel, String eventId, bool isFromMoreScreen) async {
    String response;
    try {
      var signUpSecondStepData;
      if(eventId == null) {
        if(_isHeadacheFetched) {
          SelectedAnswers headacheNameSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element) => element.questionTag == 'nameClinicalImpression', orElse: () => null);
          if(headacheNameSelectedAnswer != null) {
            var headacheNameObj = headacheListModelData.firstWhere((element) => element.text == headacheNameSelectedAnswer.answer, orElse: () => null);
            if(headacheNameObj == null) {
              signUpSecondStepData = await _signUpOnBoardFirstStepRepository
                  .signUpWelcomeOnBoardSecondStepServiceCall(
                  '${WebservicePost.qaServerUrl}event',
                  RequestMethod.POST,
                  signUpOnBoardSelectedAnswersModel);
            } else {
              response = 'You have already used this headache name. Please use different one.';
              return response;
            }
          } else {
            response = '${Constant.somethingWentWrong} Please try again later.';
            return response;
          }
        } else {
          await fetchAllHeadacheListData(Constant.blankString, false);
          if(_isHeadacheFetched) {
            SelectedAnswers headacheNameSelectedAnswer = signUpOnBoardSelectedAnswersModel.selectedAnswers.firstWhere((element) => element.questionTag == 'nameClinicalImpression', orElse: () => null);
            if(headacheNameSelectedAnswer != null) {
              var headacheNameObj = headacheListModelData.firstWhere((element) => element.text == headacheNameSelectedAnswer.answer, orElse: () => null);
              if(headacheNameObj == null) {
                signUpSecondStepData = await _signUpOnBoardFirstStepRepository
                    .signUpWelcomeOnBoardSecondStepServiceCall(
                    '${WebservicePost.qaServerUrl}event',
                    RequestMethod.POST,
                    signUpOnBoardSelectedAnswersModel);
              } else {
                response = 'Please use different headache name.';
                return response;
              }
            } else {
              response = '${Constant.somethingWentWrong} Please try again later.';
              return response;
            }
          } else {
            response = '${Constant.somethingWentWrong} Please try again later.';
            return response;
          }
        }
      } else {
        signUpSecondStepData = await _signUpOnBoardFirstStepRepository
            .signUpWelcomeOnBoardSecondStepServiceCall(
            '${WebservicePost.qaServerUrl}event/$eventId',
            RequestMethod.POST,
            signUpOnBoardSelectedAnswersModel);
      }
      if (signUpSecondStepData is AppException) {
        print(signUpSecondStepData);
        response = signUpSecondStepData.toString();
        sendSecondStepDataSink.addError(signUpSecondStepData);
      } else {
        print(signUpSecondStepData);
        if(signUpSecondStepData != null) {
          if(isFromMoreScreen) {
            var responseModelList = ResponseModel.fromJson(jsonDecode(signUpSecondStepData));
            this.eventId = responseModelList.id.toString();
          }
          response = Constant.success;
        } else {
          sendSecondStepDataSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch (e) {
      response = Constant.somethingWentWrong;
      sendSecondStepDataSink.addError(Exception(Constant.somethingWentWrong));
      //  signUpFirstStepDataSink.add("Error");
    }
    return response;
  }

  void enterSomeDummyDataToStreamController() {
    sendSecondStepDataSink.add(Constant.loading);
  }
}
