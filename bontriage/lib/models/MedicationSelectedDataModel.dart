import 'dart:convert';

MedicationSelectedDataModel medicationSelectedDateModelFromJson(String str) => MedicationSelectedDataModel.fromJson(json.decode(str));

String medicationSelectedDataModelToJson(MedicationSelectedDataModel data) => json.encode(data.toJson());

class MedicationSelectedDataModel {
  MedicationSelectedDataModel({
    this.selectedMedicationIndex,
    this.selectedMedicationDateList,
    this.selectedMedicationDosageList,
  });

  int selectedMedicationIndex;
  List<String> selectedMedicationDateList;
  List<String> selectedMedicationDosageList;

  factory MedicationSelectedDataModel.fromJson(Map<String, dynamic> json) => MedicationSelectedDataModel(
    selectedMedicationIndex: json["selectedMedicationIndex"],
    selectedMedicationDateList: List<String>.from(json["selectedMedicationDateList"].map((x) => x)),
    selectedMedicationDosageList: List<String>.from(json["selectedMedicationDosageList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "selectedMedicationIndex": selectedMedicationIndex,
    "selectedMedicationDateList": List<dynamic>.from(selectedMedicationDateList.map((x) => x)),
    "selectedMedicationDosageList": List<dynamic>.from(selectedMedicationDosageList.map((x) => x)),
  };
}