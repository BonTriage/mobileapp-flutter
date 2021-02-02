// To parse this JSON data, do
//
//     final addHeadacheResponseModel = addHeadacheResponseModelFromJson(jsonString);

import 'dart:convert';

AddHeadacheResponseModel addHeadacheResponseModelFromJson(String str) => AddHeadacheResponseModel.fromJson(json.decode(str));

String addHeadacheResponseModelToJson(AddHeadacheResponseModel data) => json.encode(data.toJson());

class AddHeadacheResponseModel {
  AddHeadacheResponseModel({
    this.id,
    this.userId,
    this.uploadedAt,
    this.updatedAt,
    this.calendarEntryAt,
    this.eventType,
    this.mobileEventDetails,
  });

  int id;
  int userId;
  DateTime uploadedAt;
  DateTime updatedAt;
  DateTime calendarEntryAt;
  String eventType;
  List<AddHeadacheMobileEventDetail> mobileEventDetails;

  factory AddHeadacheResponseModel.fromJson(Map<String, dynamic> json) => AddHeadacheResponseModel(
    id: json["id"],
    userId: json["user_id"],
    uploadedAt: DateTime.tryParse(json["uploaded_at"]),
    updatedAt: DateTime.tryParse(json["updated_at"]),
    calendarEntryAt: DateTime.tryParse(json["calendar_entry_at"]),
    eventType: json["event_type"],
    mobileEventDetails: List<AddHeadacheMobileEventDetail>.from(json["mobile_event_details"].map((x) => AddHeadacheMobileEventDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "uploaded_at": uploadedAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "calendar_entry_at": calendarEntryAt?.toIso8601String(),
    "event_type": eventType,
    "mobile_event_details": List<dynamic>.from(mobileEventDetails.map((x) => x.toJson())),
  };
}

class AddHeadacheMobileEventDetail {
  AddHeadacheMobileEventDetail({
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

  factory AddHeadacheMobileEventDetail.fromJson(Map<String, dynamic> json) => AddHeadacheMobileEventDetail(
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
