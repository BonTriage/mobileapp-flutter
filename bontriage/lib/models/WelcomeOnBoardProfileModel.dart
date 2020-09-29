class WelcomeOnBoardProfileModel {
  String initialQuestionnaire;
  List<Questionnaires> questionnaires;

  WelcomeOnBoardProfileModel({this.initialQuestionnaire, this.questionnaires});

  WelcomeOnBoardProfileModel.fromJson(Map<String, dynamic> json) {
    initialQuestionnaire = json['initial_questionnaire'];
    if (json['questionnaires'] != null) {
      questionnaires = new List<Questionnaires>();
      json['questionnaires'].forEach((v) {
        questionnaires.add(new Questionnaires.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['initial_questionnaire'] = this.initialQuestionnaire;
    if (this.questionnaires != null) {
      data['questionnaires'] =
          this.questionnaires.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questionnaires {
  String tag;
  String precondition;
  String next;
  String initialQuestion;
  List<QuestionGroups> questionGroups;
  String updatedAt;

  Questionnaires(
      {this.tag,
        this.precondition,
        this.next,
        this.initialQuestion,
        this.questionGroups,
        this.updatedAt});

  Questionnaires.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    precondition = json['precondition'];
    next = json['next'];
    initialQuestion = json['initial_question'];
    if (json['question_groups'] != null) {
      questionGroups = new List<QuestionGroups>();
      json['question_groups'].forEach((v) {
        questionGroups.add(new QuestionGroups.fromJson(v));
      });
    }
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['precondition'] = this.precondition;
    data['next'] = this.next;
    data['initial_question'] = this.initialQuestion;
    if (this.questionGroups != null) {
      data['question_groups'] =
          this.questionGroups.map((v) => v.toJson()).toList();
    }
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class QuestionGroups {
  int groupNumber;
  List<Questions> questions;

  QuestionGroups({this.groupNumber, this.questions});

  QuestionGroups.fromJson(Map<String, dynamic> json) {
    groupNumber = json['group_number'];
    if (json['questions'] != null) {
      questions = new List<Questions>();
      json['questions'].forEach((v) {
        questions.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_number'] = this.groupNumber;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String tag;
  int id;
  String questionType;
  String precondition;
  String next;
  String text;
  String helpText;
  List<Values> values;
  int min;
  int max;
  String updatedAt;
  String exclusiveValue;
  int phi;
  int required;
  String uiHints;

  Questions(
      {this.tag,
        this.id,
        this.questionType,
        this.precondition,
        this.next,
        this.text,
        this.helpText,
        this.values,
        this.min,
        this.max,
        this.updatedAt,
        this.exclusiveValue,
        this.phi,
        this.required,
        this.uiHints});

  Questions.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    id = json['id'];
    questionType = json['question_type'];
    precondition = json['precondition'];
    next = json['next'];
    text = json['text'];
    helpText = json['help_text'];
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
    min = json['min'];
    max = json['max'];
    updatedAt = json['updated_at'];
    exclusiveValue = json['exclusive_value'];
    phi = json['phi'];
    required = json['required'];
    uiHints = json['ui_hints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['id'] = this.id;
    data['question_type'] = this.questionType;
    data['precondition'] = this.precondition;
    data['next'] = this.next;
    data['text'] = this.text;
    data['help_text'] = this.helpText;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    data['min'] = this.min;
    data['max'] = this.max;
    data['updated_at'] = this.updatedAt;
    data['exclusive_value'] = this.exclusiveValue;
    data['phi'] = this.phi;
    data['required'] = this.required;
    data['ui_hints'] = this.uiHints;
    return data;
  }
}

class Values {
  String valueNumber;
  String text;

  Values({this.valueNumber, this.text});

  Values.fromJson(Map<String, dynamic> json) {
    valueNumber = json['value_number'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value_number'] = this.valueNumber;
    data['text'] = this.text;
    return data;
  }
}