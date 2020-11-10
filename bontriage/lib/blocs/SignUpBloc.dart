import 'dart:async';

import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/SignUpRepository.dart';
import 'package:mobile/util/WebservicePost.dart';

class SignUpBloc {
  SignUpRepository _signUpRepository;
  StreamController<String> _albumStreamController;
  int count = 0;

  StreamSink<String> get albumDataSink => _albumStreamController.sink;

  Stream<String> get albumDataStream => _albumStreamController.stream;

  SignUpBloc({this.count = 0}) {
    _albumStreamController = StreamController<String>();
    _signUpRepository = SignUpRepository();
    _albumStreamController.add("event");
    fetchAlbumData();
  }

  fetchAlbumData() async {
    albumDataSink.add("Trying");
    try {
      var album = await _signUpRepository.serviceCall(
          WebservicePost.qaServerUrl + 'questionnaire', RequestMethod.POST);
      if (album is AppException) {
        albumDataSink.add(album.toString());
      } else {
        albumDataSink.add(
            album.questionnaires[0].questionGroups[0].questions[count].tag);
      }
    } catch (Exception) {
      albumDataSink.add("Error");
    }
  }

  void dispose() {
    _albumStreamController?.close();
  }
}
