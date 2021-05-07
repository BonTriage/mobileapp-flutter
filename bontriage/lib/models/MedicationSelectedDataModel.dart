import 'dart:convert';

import 'package:mobile/models/QuestionsModel.dart';

MedicationSelectedDataModel medicationSelectedDateModelFromJson(String str) => MedicationSelectedDataModel.fromJson(json.decode(str));

String medicationSelectedDataModelToJson(MedicationSelectedDataModel data) => json.encode(data.toJson());

class MedicationSelectedDataModel {
  MedicationSelectedDataModel({
    this.selectedMedicationIndex,
    this.selectedMedicationDateList,
    this.selectedMedicationDosageList,
  });

  List<Values> selectedMedicationIndex;
  List<List<String>> selectedMedicationDateList;
  List<List<String>> selectedMedicationDosageList;

  factory MedicationSelectedDataModel.fromJson(Map<String, dynamic> json) => MedicationSelectedDataModel(
    selectedMedicationIndex: List<Values>.from(json["selectedMedicationIndex"].map((y) => Values.fromJson(y))),
    selectedMedicationDateList: List<List<String>>.from(json["selectedMedicationDateList"].map((x) => List<String>.from(x.map((y) => y)))),
    selectedMedicationDosageList: List<List<String>>.from(json["selectedMedicationDosageList"].map((x) => List<String>.from(x.map((y) => y)))),
  );

  Map<String, dynamic> toJson() => {
    "selectedMedicationIndex": List<dynamic>.from(selectedMedicationIndex.map((x) => x)),
    "selectedMedicationDateList": List<dynamic>.from(selectedMedicationDateList.map((x) => List<dynamic>.from(x.map((y) => y)))),
    "selectedMedicationDosageList": List<dynamic>.from(selectedMedicationDosageList.map((x) => List<dynamic>.from(x.map((y) => y)))),
  };
}