import 'dart:async';
import 'dart:convert';

import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/repository/MoreMyProfileRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class MoreMyProfileBloc {

  StreamController<dynamic> _myProfileStreamController;

  Stream<dynamic> get myProfileStream => _myProfileStreamController.stream;
  StreamSink<dynamic> get myProfileSink => _myProfileStreamController.sink;

  StreamController<dynamic> _networkStreamController;

  Stream<dynamic> get networkStream => _networkStreamController.stream;
  StreamSink<dynamic> get networkSink => _networkStreamController.sink;

  MoreMyProfileRepository _moreMyProfileRepository;
  UserProfileInfoModel userProfileInfoModel;
  List<SelectedAnswers> profileSelectedAnswerList;

  int profileId;

  MoreMyProfileBloc() {
    _myProfileStreamController = StreamController<dynamic>();
    _moreMyProfileRepository = MoreMyProfileRepository();
  }

  Future<void> fetchMyProfileData() async {
    userProfileInfoModel = await _moreMyProfileRepository.getUserProfileInfoModel();

    if(userProfileInfoModel != null) {
      try {
        String url = '${WebservicePost.qaServerUrl}event/?event_type=profile&latest_event_only=true&user_id=${userProfileInfoModel.userId}';
        var response = await _moreMyProfileRepository.myProfileServiceCall(url, RequestMethod.GET);
        if (response is AppException) {
          myProfileSink.addError(response);
          networkSink.addError(response);
        } else {
          if (response != null && response is ResponseModel) {
            print('Id:' + response.id.toString());
            profileId = response.id;
            profileSelectedAnswerList = [];
            response.mobileEventDetails.forEach((element) {
              profileSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: element.value));
            });

            SelectedAnswers genderSelectedAnswers = profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileGenderTag, orElse: () => null);
            if(genderSelectedAnswers == null)
              profileSelectedAnswerList.add(SelectedAnswers(questionTag: Constant.profileGenderTag, answer: ''));

            networkSink.add(Constant.success);
            myProfileSink.add(response);
          } else {
            myProfileSink.addError(Exception(Constant.somethingWentWrong));
            networkSink.addError(Exception(Constant.somethingWentWrong));
          }
        }
      } catch (e) {
        myProfileSink.addError(Exception(Constant.somethingWentWrong));
        networkSink.addError(Exception(Constant.somethingWentWrong));
      }
    } else {
      networkSink.add(Constant.success);
    }
  }

  Future<void> editMyProfileServiceCall() async {
    if(userProfileInfoModel != null && profileId != null) {
      try {
        String url = '${WebservicePost.qaServerUrl}event/$profileId';
        var response = await _moreMyProfileRepository.editMyProfileServiceCall(url, RequestMethod.POST, profileSelectedAnswerList);
        if (response is AppException) {
          myProfileSink.addError(response);
          networkSink.addError(response);
        } else {
          if (response != null && response is ResponseModel) {
            print('Id:' + response.id.toString());
            profileId = response.id;
            profileSelectedAnswerList = [];
            response.mobileEventDetails.forEach((element) {
              profileSelectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: element.value));
            });

            SelectedAnswers genderSelectedAnswers = profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileGenderTag, orElse: () => null);
            if(genderSelectedAnswers == null)
              profileSelectedAnswerList.add(SelectedAnswers(questionTag: Constant.profileGenderTag, answer: ''));

            _updateUserProfileInfoInDatabase();

            networkSink.add(Constant.success);
            myProfileSink.add(response);
          } else {
            myProfileSink.addError(Exception(Constant.somethingWentWrong));
            networkSink.addError(Exception(Constant.somethingWentWrong));
          }
        }
      } catch (e) {
        myProfileSink.addError(Exception(Constant.somethingWentWrong));
        networkSink.addError(Exception(Constant.somethingWentWrong));
      }
    } else {
      networkSink.add(Constant.success);
    }
  }

  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void enterSomeDummyData() {
    networkSink.add(Constant.loading);
  }

  void dispose() {
    _myProfileStreamController?.close();
    _networkStreamController?.close();
  }

  void _updateUserProfileInfoInDatabase() {
    if(profileSelectedAnswerList != null) {
      SelectedAnswers nameSelectedAnswer = profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileFirstNameTag, orElse: () => null);
      SelectedAnswers ageSelectedAnswer = profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileAgeTag, orElse: () => null);
      SelectedAnswers sexSelectedAnswer = profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileSexTag, orElse: () => null);

      if(nameSelectedAnswer != null && ageSelectedAnswer != null && sexSelectedAnswer != null) {
        if(nameSelectedAnswer.answer.isNotEmpty && ageSelectedAnswer.answer.isNotEmpty && sexSelectedAnswer.answer.isNotEmpty) {
          userProfileInfoModel
              ..firstName = nameSelectedAnswer.answer
              ..age = ageSelectedAnswer.answer
              ..sex = sexSelectedAnswer.answer;

          SignUpOnBoardProviders.db.updateUserProfileInfoModel(userProfileInfoModel);
        }
      }
    }
  }

  void setSelectedAnswerList(List<SelectedAnswers> selectedAnswerList, ResponseModel triggerMedicationValues) {
    triggerMedicationValues.mobileEventDetails.forEach((element) {
      List<String> splitList = element.value.split('%@');
      String answer = jsonEncode(splitList);
      selectedAnswerList.add(SelectedAnswers(questionTag: element.questionTag, answer: answer));
    });
  }
}