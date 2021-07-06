import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CustomTextWidget.dart';
import 'package:mobile/view/MoreSection.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class MoreSettingScreen extends StatefulWidget {
  final Future<dynamic> Function(BuildContext, String, dynamic) onPush;

  const MoreSettingScreen({Key key, this.onPush}) : super(key: key);

  @override
  _MoreSettingScreenState createState() => _MoreSettingScreenState();
}

class _MoreSettingScreenState extends State<MoreSettingScreen> {
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
                          CustomTextWidget(
                            text: 'Settings',
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
                        Consumer<MoreSettingInfo>(
                          builder: (context, data, child) {
                            return MoreSection(
                              currentTag: Constant.notifications,
                              text: Constant.notifications,
                              moreStatus: data.getNotificationStatus(),
                              isShowDivider: false,
                              navigateToOtherScreenCallback: _navigateToOtherScreen,
                            );
                          },
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
    await widget.onPush(context, routeName, arguments);
    _checkNotificationStatus();
  }

  void _checkNotificationStatus() async {
    var notificationListData =
        await SignUpOnBoardProviders.db.getAllLocalNotificationsData();

    var moreSettingInfo = Provider.of<MoreSettingInfo>(context, listen: false);

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
        moreSettingInfo.updateMoreSettingInfo(Constant.allowed);
      } else {
        moreSettingInfo.updateMoreSettingInfo(Constant.notAllowed);
      }
    } else {
      if (notificationListData == null || notificationListData.isEmpty) {
        moreSettingInfo.updateMoreSettingInfo(Constant.notAllowed);
      } else {
        moreSettingInfo.updateMoreSettingInfo(Constant.allowed);
      }
    }
  }
}

class MoreSettingInfo with ChangeNotifier {
  String _notificationStatus = Constant.notAllowed;
  String getNotificationStatus() => _notificationStatus;

  updateMoreSettingInfo(String notificationStatus) {
    _notificationStatus = notificationStatus;
    notifyListeners();
  }
}
