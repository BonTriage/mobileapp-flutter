import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreSettingScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;

  const MoreSettingScreen({Key key, this.onPush})
      : super(key: key);
  @override
  _MoreSettingScreenState createState() => _MoreSettingScreenState();
}

class _MoreSettingScreenState extends State<MoreSettingScreen> {
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
                              width: 20,
                              height: 20,
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
                                  fontFamily: Constant.jostMedium),
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
                            moreStatus: Constant.allowed,
                            isShowDivider: true,
                            navigateToOtherScreenCallback: _navigateToOtherScreen,
                          ),
                          MoreSection(
                            currentTag: Constant.locationServices,
                            text: Constant.locationServices,
                            moreStatus: Constant.allowed,
                            isShowDivider: true,
                            navigateToOtherScreenCallback: _navigateToOtherScreen,
                          ),
                          MoreSection(
                            text: Constant.appleWatch,
                            moreStatus: Constant.notSetUp,
                            isShowDivider: true,
                          ),
                          MoreSection(
                            text: Constant.appleHealth,
                            moreStatus: Constant.connected,
                            isShowDivider: true,
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Text(
                              Constant.reset,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: Constant.jostMedium,
                                color: Constant.addCustomNotificationTextColor
                              ),
                            ),
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

  void _navigateToOtherScreen(String routeName) {
    widget.onPush(
        context, routeName);
  }
}
