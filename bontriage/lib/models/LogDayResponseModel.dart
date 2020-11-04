import 'WelcomeOnBoardProfileModel.dart';

class LogDayResponseModel {
  WelcomeOnBoardProfileModel medication;
  WelcomeOnBoardProfileModel behaviors;
  WelcomeOnBoardProfileModel triggers;

  LogDayResponseModel({this.medication, this.behaviors, this.triggers});

  LogDayResponseModel.fromJson(Map<String, dynamic> json) {
    medication = WelcomeOnBoardProfileModel.fromJson(json['medication']);
    behaviors = WelcomeOnBoardProfileModel.fromJson(json['behaviors']);
    triggers = WelcomeOnBoardProfileModel.fromJson(json['triggers']);
  }
}