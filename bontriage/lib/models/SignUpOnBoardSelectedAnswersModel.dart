import 'package:mobile/providers/SignUpOnBoardProviders.dart';

class SignUpOnBoardSelectedAnswersModel {
  String eventType;
  String calendarEntryAt;
  List<SelectedAnswers> selectedAnswers;

  SignUpOnBoardSelectedAnswersModel({this.eventType, this.selectedAnswers});

  SignUpOnBoardSelectedAnswersModel.fromJson(Map<String, dynamic> json) {
    eventType = json['event_type'];
    calendarEntryAt = json['calendar_entry_at'];
    if (json['selected_answers'] != null) {
      selectedAnswers = new List<SelectedAnswers>();
      json['selected_answers'].forEach((v) {
        selectedAnswers.add(new SelectedAnswers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[SignUpOnBoardProviders.EVENT_TYPE] = this.eventType;
    if (this.selectedAnswers != null) {
      data[SignUpOnBoardProviders.SELECTED_ANSWERS] =
          this.selectedAnswers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedAnswers {
  String questionTag;
  String answer;

  SelectedAnswers({this.questionTag, this.answer});

  SelectedAnswers.fromJson(Map<dynamic, dynamic> json) {
    questionTag = json['questionTag'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionTag'] = this.questionTag;
    data['answer'] = this.answer;
    return data;
  }
}
