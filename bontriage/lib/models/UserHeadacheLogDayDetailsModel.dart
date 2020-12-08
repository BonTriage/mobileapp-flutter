class UserHeadacheLogDayDetailsModel {
  List<RecordWidgetData> headacheLogDayListData;
  String logDayNote;

  UserHeadacheLogDayDetailsModel(
      {this.headacheLogDayListData, this.logDayNote});
}

class RecordWidgetData {
  String imagePath;
  List<HeadacheData> headacheListData = [];
  LogDayData logDayListData;

   RecordWidgetData(
      {this.headacheListData, this.imagePath, this.logDayListData});
}

class HeadacheData {
  String headacheName;
  String headacheInfo;
  String headacheNote;

  HeadacheData({this.headacheNote, this.headacheInfo, this.headacheName});
}

class LogDayData {
  String titleName;
  String titleInfo;

  LogDayData({this.titleInfo, this.titleName});
}
