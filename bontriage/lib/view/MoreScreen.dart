import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreScreen extends StatefulWidget {
  final Function(BuildContext, String, dynamic) onPush;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;
  final Function(String, dynamic) openActionSheetCallback;
  final Function(Stream, Function) showApiLoaderCallback;

  const MoreScreen(
      {Key key,
      this.onPush,
      this.openActionSheetCallback,
      this.navigateToOtherScreenCallback,
      this.showApiLoaderCallback})
      : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    super.initState();
    print('More Screen');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MoreSection(
                      currentTag: Constant.myProfile,
                      text: Constant.myProfile,
                      moreStatus: '',
                      isShowDivider: true,
                      navigateToOtherScreenCallback: _navigateToOtherScreen,
                    ),
                    MoreSection(
                      currentTag: Constant.generateReport,
                      text: Constant.generateReport,
                      moreStatus: '',
                      isShowDivider: true,
                      navigateToOtherScreenCallback: _navigateToOtherScreen,
                    ),
                    MoreSection(
                      currentTag: Constant.settings,
                      text: 'Settings',
                      moreStatus: '',
                      isShowDivider: true,
                      navigateToOtherScreenCallback: _navigateToOtherScreen,
                    ),
                    MoreSection(
                      currentTag: Constant.support,
                      text: Constant.support,
                      moreStatus: '',
                      isShowDivider: false,
                      navigateToOtherScreenCallback: _navigateToOtherScreen,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BouncingWidget(
                    onPressed: () {
                      _logOutFromApp();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Constant.locationServiceGreen, width: 2)),
                      child: Text(
                        Constant.logOut,
                        style: TextStyle(
                          fontSize: 14,
                          color: Constant.locationServiceGreen,
                          fontFamily: Constant.jostMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Visibility(
                visible: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BouncingWidget(
                      onPressed: () {
                        //_showDeleteLogOptionBottomSheet();
                        widget.openActionSheetCallback(
                            Constant.medicalHelpActionSheet, null);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Constant.chatBubbleGreen),
                        child: Text(
                          'I need medical help',
                          style: TextStyle(
                            fontSize: 14,
                            color: Constant.bubbleChatTextView,
                            fontFamily: Constant.jostMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToOtherScreen(String routeName, dynamic arguments) {
    widget.onPush(context, routeName, arguments);
  }

  ///This method is used to log out from the app and redirecting to the welcome start assessment screen
  void _logOutFromApp() async {
    var result = await Utils.showConfirmationDialog(
        context, 'Are you sure want to log out?', 'Logout?');
    if (result == 'Yes') {
      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        bool isVolume =
            sharedPreferences.getBool(Constant.chatBubbleVolumeState);
        sharedPreferences.clear();
        sharedPreferences.setBool(Constant.chatBubbleVolumeState, isVolume);
        sharedPreferences.setBool(Constant.tutorialsState, true);
        await SignUpOnBoardProviders.db.deleteAllTableData();
        flutterLocalNotificationsPlugin?.cancelAll();
      } catch (e) {
        print(e);
      }
      widget.navigateToOtherScreenCallback(
          Constant.welcomeStartAssessmentScreenRouter, null);
    }
  }
}
