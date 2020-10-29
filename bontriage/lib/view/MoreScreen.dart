import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Function(String) openActionSheetCallback;

  const MoreScreen({Key key, this.onPush, this.openActionSheetCallback})
      : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    // TODO: implement initState
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
                      currentTag: Constant.settings,
                      text: 'Settings',
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
                      //_showDeleteLogOptionBottomSheet();
                      widget.openActionSheetCallback(
                          Constant.medicalHelpActionSheet);
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
                            fontFamily: Constant.jostMedium,),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
