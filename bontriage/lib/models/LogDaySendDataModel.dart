import 'dart:convert';

import 'SignUpOnBoardAnswersRequestModel.dart';

class LogDaySendDataModel {
  SignUpOnBoardAnswersRequestModel behaviors;
  List<SignUpOnBoardAnswersRequestModel> medication;
  SignUpOnBoardAnswersRequestModel triggers;
  SignUpOnBoardAnswersRequestModel note;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['behaviors'] = behaviors.toJson();
    data['medication'] = medication;
    data['triggers'] = triggers.toJson();
    data['note'] = note.toJson();
    return data;
  }
}