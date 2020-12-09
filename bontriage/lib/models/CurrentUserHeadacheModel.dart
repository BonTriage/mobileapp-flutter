class CurrentUserHeadacheModel {
  String userId;
  String selectedDate;
  String selectedEndDate;
  bool isOnGoing;

  CurrentUserHeadacheModel({this.userId, this.selectedDate, this.selectedEndDate, this.isOnGoing});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'userId': userId,
      'selectedDate': selectedDate,
      'selectedEndDate': selectedEndDate,
      'isOnGoing': isOnGoing
    };
    return map;
  }

  CurrentUserHeadacheModel.fromJson(Map<String,dynamic> map){
    userId = map['userId'];
    selectedDate = map['selectedDate'];
    selectedEndDate = map['selectedEndDate'];
    isOnGoing = map['isOnGoing'];
  }
}