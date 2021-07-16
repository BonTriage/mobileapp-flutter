import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChangePasswordScreen.dart';
import 'package:mobile/view/MoreSection.dart';

import '../main.dart';

class MoreSettingScreen extends StatefulWidget {
  final Future<dynamic> Function(BuildContext, String, dynamic) onPush;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;

  const MoreSettingScreen({
    Key key,
    this.onPush,
    this.navigateToOtherScreenCallback,}) : super(key: key);

  @override
  _MoreSettingScreenState createState() => _MoreSettingScreenState();
}

class _MoreSettingScreenState extends State<MoreSettingScreen> {
  String _notificationStatus = Constant.notAllowed;
  String _locationStatus = Constant.notAllowed;

  @override
  void initState() {
    super.initState();

    _checkNotificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Constant.moreBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Image(
                            width: 16,
                            height: 16,
                            image: AssetImage(Constant.leftArrow),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Settings',
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostRegular),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MoreSection(
                          currentTag: Constant.notifications,
                          text: Constant.notifications,
                          moreStatus: _notificationStatus,
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.locationServices,
                          text: Constant.locationServices,
                          moreStatus: _locationStatus,
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.changePassword,
                          text: Constant.changePassword,
                          moreStatus: Constant.blankString,
                          isShowDivider: false,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToOtherScreen(String routeName, dynamic arguments) async {
    if(routeName == Constant.changePasswordScreenRouter) {
      UserProfileInfoModel userProfileInfoModel = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
      widget.navigateToOtherScreenCallback(routeName, ChangePasswordArgumentModel(
        emailValue: userProfileInfoModel.email,
        isFromMoreSettings: true,
        isFromSignUp: false,
      ));
    } else {
      await widget.onPush(context, routeName, arguments);
      _checkNotificationStatus();
    }
  }

  void _checkNotificationStatus() async {
    var notificationListData =
        await SignUpOnBoardProviders.db.getAllLocalNotificationsData();

    bool isLocationAllowed = await Utils.checkLocationPermission();

    if(isLocationAllowed ?? false) {
      _locationStatus = Constant.allowed;
    }

    if (Platform.isIOS) {
      var permissionResult = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (permissionResult ?? false) {
        setState(() {
          _notificationStatus = Constant.allowed;
        });
      } else {
        setState(() {
          _notificationStatus = Constant.notAllowed;
        });
      }
    } else {
      if (notificationListData == null || notificationListData.isEmpty) {
        setState(() {
          _notificationStatus = Constant.notAllowed;
        });
      } else {
        setState(() {
          _notificationStatus = Constant.allowed;
        });
      }
    }
  }
}
