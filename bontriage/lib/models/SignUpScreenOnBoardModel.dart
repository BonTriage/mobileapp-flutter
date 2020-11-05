
import 'dart:convert';

SignUpScreenOnBoardModel signUpScreenOnBoardModelFromJson(String str) => SignUpScreenOnBoardModel.fromJson(json.decode(str));

String signUpScreenOnBoardModelToJson(SignUpScreenOnBoardModel data) => json.encode(data.toJson());

class SignUpScreenOnBoardModel {
  SignUpScreenOnBoardModel({
    this.age,
    this.email,
    this.firstName,
    this.lastName,
    this.location,
    this.notificationKey,
    this.password,
    this.sex,
  });

  String age;
  String email;
  String firstName;
  String lastName;
  String location;
  String notificationKey;
  String password;
  String sex;

  factory SignUpScreenOnBoardModel.fromJson(Map<String, dynamic> json) => SignUpScreenOnBoardModel(
    age: json["age"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    location: json["location"],
    notificationKey: json["notification_key"],
    password: json["password"],
    sex: json["sex"],
  );

  Map<String, dynamic> toJson() => {
    "age": age,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "location": location,
    "notification_key": notificationKey,
    "password": password,
    "sex": sex,
  };
}
