import 'package:mobile/util/constant.dart';

import 'RecordsTrendsDataModel.dart';

class EditGraphViewFilterModel {
  String singleTypeHeadacheSelected;
  String compareHeadacheTypeSelected1;
  String compareHeadacheTypeSelected2;

  //None, Logged Behaviors, LoggedPotentialTriggers, and Medications
  String whichOtherFactorSelected;

  RecordsTrendsDataModel recordsTrendsDataModel;
  int currentTabIndex;



  EditGraphViewFilterModel({
    this.singleTypeHeadacheSelected,
    this.compareHeadacheTypeSelected1,
    this.compareHeadacheTypeSelected2,
    this.whichOtherFactorSelected = Constant.noneRadioButtonText,
    this.recordsTrendsDataModel,
    this.currentTabIndex = 0,
  });
}