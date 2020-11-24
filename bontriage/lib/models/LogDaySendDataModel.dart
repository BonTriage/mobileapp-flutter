import 'SignUpOnBoardAnswersRequestModel.dart';

class LogDaySendDataModel {
  SignUpOnBoardAnswersRequestModel behaviors;
  SignUpOnBoardAnswersRequestModel medication;
  SignUpOnBoardAnswersRequestModel triggers;
  SignUpOnBoardAnswersRequestModel note;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['behaviors'] = behaviors.toJson();
    data['medication'] = medication.toJson();
    data['triggers'] = triggers.toJson();
    data['note'] = note.toJson();
    return data;
  }
}