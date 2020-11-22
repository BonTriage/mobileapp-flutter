class CurrentUserHeadacheModel {
  String userId;
  String selectedDate;

  CurrentUserHeadacheModel({this.userId, this.selectedDate});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'userId': userId,
      'selectedDate': selectedDate,
    };
    return map;
  }

  CurrentUserHeadacheModel.fromJson(Map<String,dynamic> map){
    userId = map['userId'];
    selectedDate = map['selectedDate'];
  }
}