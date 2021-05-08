import 'package:flutter/material.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreSettingScreen extends StatefulWidget {
  final Future<dynamic> Function(BuildContext, String, dynamic) onPush;

  const MoreSettingScreen({Key key, this.onPush})
      : super(key: key);
  @override
  _MoreSettingScreenState createState() => _MoreSettingScreenState();
}

class _MoreSettingScreenState extends State<MoreSettingScreen> {

  String _notificationStatus = Constant.notAllowed;

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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
    await widget.onPush(context, routeName, arguments);
    _checkNotificationStatus();
  }

  void _checkNotificationStatus() async {
    var notificationListData = await SignUpOnBoardProviders.db.getAllLocalNotificationsData();

    if(notificationListData == null || notificationListData.isEmpty) {
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
