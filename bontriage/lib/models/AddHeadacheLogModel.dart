// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class AddHeadacheLogModel {
  AddHeadacheLogModel({
    this.initialQuestionnaire,
    this.questionnaires,
  });

  String initialQuestionnaire;
  List<Questionnaire> questionnaires;

  factory AddHeadacheLogModel.fromJson(Map<String, dynamic> json) => AddHeadacheLogModel(
    initialQuestionnaire: json["initial_questionnaire"],
    questionnaires: List<Questionnaire>.from(json["questionnaires"].map((x) => Questionnaire.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "initial_questionnaire": initialQuestionnaire,
    "questionnaires": List<dynamic>.from(questionnaires.map((x) => x.toJson())),
  };
}

class Questionnaire {
  Questionnaire({
    this.tag,
    this.precondition,
    this.next,
    this.initialQuestion,
    this.questionGroups,
    this.updatedAt,
  });

  String tag;
  String precondition;
  String next;
  String initialQuestion;
  List<QuestionGroup> questionGroups;
  DateTime updatedAt;

  factory Questionnaire.fromJson(Map<String, dynamic> json) => Questionnaire(
    tag: json["tag"],
    precondition: json["precondition"],
    next: json["next"],
    initialQuestion: json["initial_question"],
    questionGroups: List<QuestionGroup>.from(json["question_groups"].map((x) => QuestionGroup.fromJson(x))),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "precondition": precondition,
    "next": next,
    "initial_question": initialQuestion,
    "question_groups": List<dynamic>.from(questionGroups.map((x) => x.toJson())),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class QuestionGroup {
  QuestionGroup({
    this.groupNumber,
    this.questions,
  });

  int groupNumber;
  List<Question> questions;

  factory QuestionGroup.fromJson(Map<String, dynamic> json) => QuestionGroup(
    groupNumber: json["group_number"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group_number": groupNumber,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  Question({
    this.tag,
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
    this.uiHints,
  });

  String tag;
  int id;
  String questionType;
  String precondition;
  String next;
  String text;
  String helpText;
  List<Value> values;
  int min;
  int max;
  DateTime updatedAt;
  String exclusiveValue;
  int phi;
  int required;
  String uiHints;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    tag: json["tag"],
    id: json["id"],
    questionType: json["question_type"],
    precondition: json["precondition"],
    next: json["next"],
    text: json["text"],
    helpText: json["help_text"],
    values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    min: json["min"],
    max: json["max"],
    updatedAt: DateTime.parse(json["updated_at"]),
    exclusiveValue: json["exclusive_value"],
    phi: json["phi"],
    required: json["required"],
    uiHints: json["ui_hints"],
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "id": id,
    "question_type": questionType,
    "precondition": precondition,
    "next": next,
    "text": text,
    "help_text": helpText,
    "values": List<dynamic>.from(values.map((x) => x.toJson())),
    "min": min,
    "max": max,
    "updated_at": updatedAt.toIso8601String(),
    "exclusive_value": exclusiveValue,
    "phi": phi,
    "required": required,
    "ui_hints": uiHints,
  };
}

class Value {
  Value({
    this.valueNumber,
    this.text,
  });

  String valueNumber;
  String text;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    valueNumber: json["value_number"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "value_number": valueNumber,
    "text": text,
  };
}
