class SignUpOnBoardAnswersRequestModel {
  String calendarEntryAt;
  String eventType;
  List<MobileEventDetails> mobileEventDetails;
  String updatedAt;
  int userId;

  SignUpOnBoardAnswersRequestModel(
      {this.calendarEntryAt,
        this.eventType,
        this.mobileEventDetails,
        this.updatedAt,
        this.userId});

  SignUpOnBoardAnswersRequestModel.fromJson(Map<String, dynamic> json) {
    calendarEntryAt = json['calendar_entry_at'];
    eventType = json['event_type'];
    if (json['mobile_event_details'] != null) {
      mobileEventDetails = new List<MobileEventDetails>();
      json['mobile_event_details'].forEach((v) {
        mobileEventDetails.add(new MobileEventDetails.fromJson(v));
      });
    }
    updatedAt = json['updated_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calendar_entry_at'] = this.calendarEntryAt;
    data['event_type'] = this.eventType;
    if (this.mobileEventDetails != null) {
      data['mobile_event_details'] =
          this.mobileEventDetails.map((v) => v.toJson()).toList();
    }
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    return data;
  }
}

class MobileEventDetails {
  String questionJson;
  String questionTag;
  String updatedAt;
  List<String> value;

  MobileEventDetails(
      {this.questionJson, this.questionTag, this.updatedAt, this.value});

  MobileEventDetails.fromJson(Map<String, dynamic> json) {
    questionJson = json['question_json'];
    questionTag = json['question_tag'];
    updatedAt = json['updated_at'];
    value = json['value'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_json'] = this.questionJson;
    data['question_tag'] = this.questionTag;
    data['updated_at'] = this.updatedAt;
    data['value'] = this.value;
    return data;
  }
}