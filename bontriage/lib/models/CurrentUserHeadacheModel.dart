class CurrentUserHeadacheModel {
  String userId;
  String selectedDate;
  String selectedEndDate;
  bool isOnGoing;
  bool isFromRecordScreen;
  int headacheId;
  bool isFromServer;  //this attribute is to identify whether this headache date came from server or not.

  CurrentUserHeadacheModel({this.userId, this.selectedDate, this.selectedEndDate, this.isOnGoing, this.isFromRecordScreen = false, this.headacheId, this.isFromServer = false});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'userId': userId,
      'selectedDate': selectedDate,
      'selectedEndDate': selectedEndDate,
      'isOnGoing': isOnGoing,
      'isFromRecordScreen': isFromRecordScreen,
      'headacheId': headacheId,
      'isFromServer': isFromServer,
    };
    return map;
  }

  CurrentUserHeadacheModel.fromJson(Map<String,dynamic> map){
    userId = map['userId'];
    selectedDate = map['selectedDate'];
    selectedEndDate = map['selectedEndDate'];
    isOnGoing = map['isOnGoing'];
    isFromRecordScreen = map['isFromRecordScreen'];
    headacheId = map['headacheId'];
    isFromServer = map['isFromServer'];
  }
}