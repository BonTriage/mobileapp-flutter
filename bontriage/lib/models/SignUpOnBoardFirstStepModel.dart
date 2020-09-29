
import 'dart:convert';



class SignUpOnBoardFirstStepModel {
  SignUpOnBoardFirstStepModel({
    this.initialQuestionnaire,
    this.questionnaires,
  });

  String initialQuestionnaire;
  List<Questionnaire> questionnaires;

  factory SignUpOnBoardFirstStepModel.fromJson(Map<String, dynamic> json) => SignUpOnBoardFirstStepModel(
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
  QuestionType questionType;
  String precondition;
  String next;
  Text text;
  String helpText;
  List<Value> values;
  int min;
  int max;
  DateTime updatedAt;
  String exclusiveValue;
  int phi;
  int required;
  UiHints uiHints;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    tag: json["tag"],
    id: json["id"],
    questionType: questionTypeValues.map[json["question_type"]],
    precondition: json["precondition"],
    next: json["next"],
    text: textValues.map[json["text"]],
    helpText: json["help_text"],
    values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    min: json["min"],
    max: json["max"],
    updatedAt: DateTime.parse(json["updated_at"]),
    exclusiveValue: json["exclusive_value"],
    phi: json["phi"],
    required: json["required"],
    uiHints: uiHintsValues.map[json["ui_hints"]],
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "id": id,
    "question_type": questionTypeValues.reverse[questionType],
    "precondition": precondition,
    "next": next,
    "text": textValues.reverse[text],
    "help_text": helpText,
    "values": List<dynamic>.from(values.map((x) => x.toJson())),
    "min": min,
    "max": max,
    "updated_at": updatedAt.toIso8601String(),
    "exclusive_value": exclusiveValue,
    "phi": phi,
    "required": required,
    "ui_hints": uiHintsValues.reverse[uiHints],
  };
}

enum QuestionType { SINGLE, NUMBER, INFO, MULTI }

final questionTypeValues = EnumValues({
  "info": QuestionType.INFO,
  "multi": QuestionType.MULTI,
  "number": QuestionType.NUMBER,
  "single": QuestionType.SINGLE
});

enum Text { EMPTY, CLINICAL_IMPRESSION }

final textValues = EnumValues({
  "Clinical Impression": Text.CLINICAL_IMPRESSION,
  "": Text.EMPTY
});

enum UiHints { EMPTY, MINLABEL_MAXLABEL }

final uiHintsValues = EnumValues({
  "": UiHints.EMPTY,
  "minlabel= ;maxlabel= ": UiHints.MINLABEL_MAXLABEL
});

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

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
