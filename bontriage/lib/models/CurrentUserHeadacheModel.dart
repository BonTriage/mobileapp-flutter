class CurrentUserHeadacheModel {
  String userId;
  String selectedDate;
  bool isOnGoing;

  CurrentUserHeadacheModel({this.userId, this.selectedDate, this.isOnGoing});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'userId': userId,
      'selectedDate': selectedDate,
      'isOnGoing': isOnGoing
    };
    return map;
  }

  CurrentUserHeadacheModel.fromJson(Map<String,dynamic> map){
    userId = map['userId'];
    selectedDate = map['selectedDate'];
    isOnGoing = map['isOnGoing'];
  }
}