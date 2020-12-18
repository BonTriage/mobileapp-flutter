import 'dart:convert';

MedicationSelectedDataModel medicationSelectedDateModelFromJson(String str) => MedicationSelectedDataModel.fromJson(json.decode(str));

String medicationSelectedDataModelToJson(MedicationSelectedDataModel data) => json.encode(data.toJson());

class MedicationSelectedDataModel {
  MedicationSelectedDataModel({
    this.selectedMedicationIndex,
    this.selectedMedicationDateList,
    this.selectedMedicationDosageList,
    this.isNewlyAdded = false,
    this.newlyAddedMedicationName,
    this.isDoubleTapped
  });

  int selectedMedicationIndex;
  List<String> selectedMedicationDateList;
  List<String> selectedMedicationDosageList;
  bool isNewlyAdded;
  String newlyAddedMedicationName;
  bool isDoubleTapped;

  factory MedicationSelectedDataModel.fromJson(Map<String, dynamic> json) => MedicationSelectedDataModel(
    selectedMedicationIndex: json["selectedMedicationIndex"],
    selectedMedicationDateList: List<String>.from(json["selectedMedicationDateList"].map((x) => x)),
    selectedMedicationDosageList: List<String>.from(json["selectedMedicationDosageList"].map((x) => x)),
    isNewlyAdded: json['isNewlyAdded'],
    newlyAddedMedicationName: json['newlyAddedMedicationName'],
    isDoubleTapped: json['isDoubleTapped'],
  );

  Map<String, dynamic> toJson() => {
    "selectedMedicationIndex": selectedMedicationIndex,
    "selectedMedicationDateList": List<dynamic>.from(selectedMedicationDateList.map((x) => x)),
    "selectedMedicationDosageList": List<dynamic>.from(selectedMedicationDosageList.map((x) => x)),
    'isNewlyAdded': isNewlyAdded,
    'newlyAddedMedicationName': newlyAddedMedicationName,
    'isDoubleTapped': isDoubleTapped,
  };
}