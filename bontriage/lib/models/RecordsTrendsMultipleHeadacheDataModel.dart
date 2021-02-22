// To parse this JSON data, do
//
//     final recordsTrendsMultipleHeadacheDataModel = recordsTrendsMultipleHeadacheDataModelFromJson(jsonString);

import 'dart:convert';

RecordsTrendsMultipleHeadacheDataModel recordsTrendsMultipleHeadacheDataModelFromJson(String str) => RecordsTrendsMultipleHeadacheDataModel.fromJson(json.decode(str));

String recordsTrendsMultipleHeadacheDataModelToJson(RecordsTrendsMultipleHeadacheDataModel data) => json.encode(data.toJson());

class RecordsTrendsMultipleHeadacheDataModel {
  RecordsTrendsMultipleHeadacheDataModel({
    this.headacheFirst,
    this.headacheSecond,
  });

  Headache headacheFirst;
  Headache headacheSecond;

  factory RecordsTrendsMultipleHeadacheDataModel.fromJson(Map<String, dynamic> json) => RecordsTrendsMultipleHeadacheDataModel(
    headacheFirst: Headache.fromJson(json["headache_first"]),
    headacheSecond: Headache.fromJson(json["headache_second"]),
  );

  Map<String, dynamic> toJson() => {
    "headache_first": headacheFirst.toJson(),
    "headache_second": headacheSecond.toJson(),
  };
}

class Headache {
  Headache({
    this.severity,
    this.duration,
    this.disability,
    this.frequency,
  });

  List<Data> severity;
  List<Data> duration;
  List<Data> disability;
  List<Data> frequency;

  factory Headache.fromJson(Map<String, dynamic> json) => Headache(
    severity: List<Data>.from(json["severity"].map((x) => Data.fromJson(x))),
    duration: List<Data>.from(json["duration"].map((x) => Data.fromJson(x))),
    disability: List<Data>.from(json["disability"].map((x) => Data.fromJson(x))),
    frequency: List<Data>.from(json["frequency"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "severity": List<dynamic>.from(severity.map((x) => x.toJson())),
    "duration": List<dynamic>.from(duration.map((x) => x.toJson())),
    "disability": List<dynamic>.from(disability.map((x) => x.toJson())),
    "frequency": List<dynamic>.from(frequency.map((x) => x.toJson())),
  };
}

class Data {
  Data({
    this.date,
    this.value,
  });

  DateTime date;
  double value;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    date: DateTime.parse(json["date"]),
    value: json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "value": value,
  };
}
