import 'SignUpOnBoardAnswersRequestModel.dart';

class LogDaySendDataModel {
  SignUpOnBoardAnswersRequestModel behaviors;
  SignUpOnBoardAnswersRequestModel medication;
  SignUpOnBoardAnswersRequestModel triggers;
  String note;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['behaviors'] = behaviors.toJson();
    data['medication'] = medication.toJson();
    data['triggers'] = triggers.toJson();
    /*data['note'] = note ?? '';*/
    return data;
  }
}