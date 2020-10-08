class SignUpOnBoardSelectedAnswersModel {
  String eventType;
  List<SelectedAnswers> selectedAnswers ;

  SignUpOnBoardSelectedAnswersModel({this.eventType, this.selectedAnswers});

  SignUpOnBoardSelectedAnswersModel.fromJson(Map<String, dynamic> json) {
    eventType = json['event_type'];
    if (json['selected_answers'] != null) {
      selectedAnswers = new List<SelectedAnswers>();
      json['selected_answers'].forEach((v) {
        selectedAnswers.add(new SelectedAnswers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_type'] = this.eventType;
    if (this.selectedAnswers != null) {
      data['selected_answers'] =
          this.selectedAnswers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedAnswers {
  String questionTag;
  String answer;

  SelectedAnswers({this.questionTag, this.answer});

  SelectedAnswers.fromJson(Map<String, dynamic> json) {
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