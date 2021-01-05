import 'dart:async';

import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
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
    profileSelectedAnswerList = [];
  }

  Future<void> fetchMyProfileData() async {
    userProfileInfoModel = await _moreMyProfileRepository.getUserProfileInfoModel();

    if(userProfileInfoModel != null) {
      try {
        //String url = '${WebservicePost.productionServerUrl}event/?event_type=profile&latest_event_only=true&user_id=4617';
        String url = '${WebservicePost.qaServerUrl}event/?event_type=profile&latest_event_only=true&user_id=${userProfileInfoModel.userId}';
        var response = await _moreMyProfileRepository.myProfileServiceCall(url, RequestMethod.GET);
        if (response is AppException) {
          myProfileSink.addError(response);
          networkSink.addError(response);
        } else {
          if (response != null && response is ResponseModel) {
            print('Id:' + response.id.toString());
            profileId = response.id;
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
}