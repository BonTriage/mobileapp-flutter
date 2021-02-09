import 'dart:convert';

import 'package:mobile/models/QuestionsModel.dart';

List<ResponseModel> responseModelFromJson(String str) => List<ResponseModel>.from(json.decode(str).map((x) => ResponseModel.fromJson(x)));

String responseModelToJson(List<ResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseModel {
  ResponseModel({
    this.id,
    this.userId,
    this.uploadedAt,
    this.updatedAt,
    this.calendarEntryAt,
    this.eventType,
    this.mobileEventDetails,
    this.headacheList,
    this.triggerMedicationValues,
    this.triggerValues,
    this.medicationValues,
  });

  int id;
  int userId;
  DateTime uploadedAt;
  DateTime updatedAt;
  DateTime calendarEntryAt;
  String eventType;
  List<ResponseMobileEventDetails> mobileEventDetails;
  List<HeadacheTypeData> headacheList;
  List<ResponseModel> triggerMedicationValues;
  List<Values> triggerValues;
  List<Values> medicationValues;


  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    id: json["id"],
    userId: json["user_id"],
    uploadedAt: DateTime.tryParse(json["uploaded_at"]),
    updatedAt: DateTime.tryParse(json["updated_at"]),
    calendarEntryAt: DateTime.tryParse(json["calendar_entry_at"]),
    eventType: json["event_type"],
    mobileEventDetails: List<ResponseMobileEventDetails>.from(json["mobile_event_details"].map((x) => ResponseMobileEventDetails.fromJson(x))),
    headacheList: json["headache_list"] != null ? List<HeadacheTypeData>.from(json["headache_list"].map((x) => HeadacheTypeData.fromJson(x))) : null,
    triggerMedicationValues: json['trigger_medication_values'] != null ? List<ResponseModel>.from(json["trigger_medication_values"].map((x) => ResponseModel.fromJson(x))) : null,
    triggerValues: json["trigger_values"] != null ? List<Values>.from(json["trigger_values"].map((x) => Values.fromJson(x))) : null,
    medicationValues: json["medication_values"] != null ? List<Values>.from(json["medication_values"].map((x) => Values.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "uploaded_at": uploadedAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "calendar_entry_at": calendarEntryAt.toIso8601String(),
    "event_type": eventType,
    "mobile_event_details": List<dynamic>.from(mobileEventDetails.map((x) => x.toJson())),
    'headache_list': List<dynamic>.from(headacheList.map((x) => x.toJson())),
    'trigger_medication_values': List<dynamic>.from(triggerMedicationValues.map((x) => x.toJson())),
    'trigger_values': List<dynamic>.from(triggerValues.map((x) => x.toJson())),
    'medication_values': List<dynamic>.from(medicationValues.map((x) => x.toJson())),
  };
}

class ResponseMobileEventDetails {
  ResponseMobileEventDetails({
    this.id,
    this.eventId,
    this.value,
    this.questionTag,
    this.questionJson,
    this.uploadedAt,
    this.updatedAt,
  });

  int id;
  int eventId;
  String value;
  String questionTag;
  String questionJson;
  DateTime uploadedAt;
  DateTime updatedAt;

  factory ResponseMobileEventDetails.fromJson(Map<String, dynamic> json) => ResponseMobileEventDetails(
    id: json["id"],
    eventId: json["event_id"],
    value: json["value"],
    questionTag: json["question_tag"],
    questionJson: json["question_json"],
    uploadedAt: DateTime.parse(json["uploaded_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_id": eventId,
    "value": value,
    "question_tag": questionTag,
    "question_json": questionJson,
    "uploaded_at": uploadedAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class HeadacheTypeData {
  String valueNumber;
  String text;
  bool isValid;
  bool isSelected;

  HeadacheTypeData({this.valueNumber, this.text, this.isValid = true, this.isSelected = false});

  HeadacheTypeData.fromJson(Map<String, dynamic> json) {
    valueNumber = json['value_number'];
    text = json['text'];
    isValid = json['is_valid'];
    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value_number'] = this.valueNumber;
    data['text'] = this.text;
    data['is_valid'] = this.isValid;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
