class LocalNotificationModel {
  String notificationName;
  String notificationTime;
  String notificationType;
  String userId;

  LocalNotificationModel(
      {this.notificationName,
      this.notificationTime,
      this.notificationType,
      this.userId});

  factory LocalNotificationModel.fromJson(Map<String, dynamic> json) =>
      LocalNotificationModel(
        notificationName: json["notificationName"],
        notificationTime: json["notificationTime"],
        notificationType: json["notificationType"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "notificationName": notificationName,
        "notificationTime": notificationTime,
        "notificationType": notificationType,
        "userId": userId,
      };
}
