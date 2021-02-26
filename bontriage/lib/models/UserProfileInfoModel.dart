import 'dart:convert';

UserProfileInfoModel userProfileInfoModelFromJson(String str) =>
    UserProfileInfoModel.fromJson(json.decode(str));

String userProfileInfoModelToJson(UserProfileInfoModel data) =>
    json.encode(data.toJson());

class UserProfileInfoModel {
  UserProfileInfoModel({
    this.userId,
    this.email,
    this.sex,
    this.age,
    this.updatedAt,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.notificationKey,
    this.profileName,
  });

  String userId;
  String email;
  String sex;
  String age;
  DateTime updatedAt;
  DateTime createdAt;
  String firstName;
  String lastName;
  String notificationKey;
  String profileName;

  factory UserProfileInfoModel.fromJson(Map<String, dynamic> json) =>
      UserProfileInfoModel(
        userId: json['id'] != null
            ? json["id"].toString()
            : json["userId"].toString(),
        email: json["email"],
        sex: json["sex"],
        age: json["age"].toString(),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        notificationKey: json["notificationKey"],
        profileName: json['profileName'],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "sex": sex,
        "age": age,
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "firstName": firstName,
        "lastName": lastName,
        "notificationKey": notificationKey,
        'profileName': profileName,
      };
}
