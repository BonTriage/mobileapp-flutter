class CalendarInfoDataModel {
  List<Headache> headache;
  List<Headache> triggers;
  List<Headache> medication;
  List<Headache> behaviours;
  List<Headache> logDayNote;

  CalendarInfoDataModel(
      {this.headache,
      this.triggers,
      this.medication,
      this.behaviours,
      this.logDayNote});

  CalendarInfoDataModel.fromJson(Map<String, dynamic> json) {
    if (json['headache'] != null) {
      headache = new List<Headache>();
      json['headache'].forEach((v) {
        headache.add(new Headache.fromJson(v));
      });
    }
    if (json['triggers'] != null) {
      triggers = new List<Headache>();
      json['triggers'].forEach((v) {
        triggers.add(new Headache.fromJson(v));
      });
    }

    if (json['medication'] != null) {
      medication = new List<Headache>();
      json['medication'].forEach((v) {
        medication.add(new Headache.fromJson(v));
      });
    }
    if (json['behaviors'] != null) {
      behaviours = new List<Headache>();
      json['behaviors'].forEach((v) {
        behaviours.add(new Headache.fromJson(v));
      });
    }

    if (json['note'] != null) {
      logDayNote = new List<Headache>();
      json['note'].forEach((v) {
        logDayNote.add(new Headache.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.headache != null) {
      data['headache'] = this.headache.map((v) => v.toJson()).toList();
    }
    if (this.triggers != null) {
      data['triggers'] = this.triggers.map((v) => v.toJson()).toList();
    }
    if (this.medication != null) {
      data['medication'] = this.medication.map((v) => v.toJson()).toList();
    }
    if (this.behaviours != null) {
      data['behaviors'] = this.behaviours.map((v) => v.toJson()).toList();
    }
    if (this.logDayNote != null) {
      data['note'] = this.logDayNote.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Headache {
  int id;
  int userId;
  String uploadedAt;
  String updatedAt;
  String calendarEntryAt;
  String eventType;
  bool isMigraine;
  List<MobileEventDetails1> mobileEventDetails;

  Headache(
      {this.id,
      this.userId,
      this.uploadedAt,
      this.updatedAt,
      this.calendarEntryAt,
      this.eventType,
      this.isMigraine,
      this.mobileEventDetails});

  Headache.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    uploadedAt = json['uploaded_at'];
    updatedAt = json['updated_at'];
    calendarEntryAt = json['calendar_entry_at'];
    eventType = json['event_type'];
    isMigraine = json['is_migraine'];
    if (json['mobile_event_details'] != null) {
      mobileEventDetails = new List<MobileEventDetails1>();
      json['mobile_event_details'].forEach((v) {
        mobileEventDetails.add(new MobileEventDetails1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['uploaded_at'] = this.uploadedAt;
    data['updated_at'] = this.updatedAt;
    data['calendar_entry_at'] = this.calendarEntryAt;
    data['event_type'] = this.eventType;
    data['is_migraine'] = this.isMigraine;
    if (this.mobileEventDetails != null) {
      data['mobile_event_details'] =
          this.mobileEventDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MobileEventDetails1 {
  int id;
  int eventId;
  String value;
  String questionTag;
  String questionJson;
  String uploadedAt;
  String updatedAt;

  MobileEventDetails1(
      {this.id,
      this.eventId,
      this.value,
      this.questionTag,
      this.questionJson,
      this.uploadedAt,
      this.updatedAt});

  MobileEventDetails1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    value = json['value'];
    questionTag = json['question_tag'];
    questionJson = json['question_json'];
    uploadedAt = json['uploaded_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_id'] = this.eventId;
    data['value'] = this.value;
    data['question_tag'] = this.questionTag;
    data['question_json'] = this.questionJson;
    data['uploaded_at'] = this.uploadedAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
