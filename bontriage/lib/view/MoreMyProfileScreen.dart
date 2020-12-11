import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreMyProfileScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Function(String) openActionSheetCallback;

  const MoreMyProfileScreen({Key key, this.onPush, this.openActionSheetCallback})
      : super(key: key);
  @override
  _MoreMyProfileScreenState createState() => _MoreMyProfileScreenState();
}

class _MoreMyProfileScreenState extends State<MoreMyProfileScreen> {
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
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
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
                            Constant.myProfile,
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
                          currentTag: Constant.name,
                          text: Constant.name,
                          moreStatus: Constant.lindaJones,
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.age,
                          text: Constant.age,
                          moreStatus: Constant.twentyTwo,
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.gender,
                          text: Constant.gender,
                          moreStatus: Constant.female,
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.sex,
                          text: Constant.sex,
                          moreStatus: Constant.female,
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Constant.reCompleteInitialAssessment,
                              style: TextStyle(
                                  color: Constant
                                      .addCustomNotificationTextColor,
                                  fontSize: 16,
                                  fontFamily: Constant.jostRegular),
                            ),
                            Image(
                              width: 16,
                              height: 16,
                              image: AssetImage(Constant.rightArrow),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Constant.headacheTypes,
                      style: TextStyle(
                        color: Constant.addCustomNotificationTextColor,
                        fontSize: 16,
                        fontFamily: Constant.jostMedium
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        MoreSection(
                          currentTag: Constant.headacheType,
                          text: Constant.headacheType,
                          moreStatus: '',
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.headacheType,
                          text: Constant.headacheType,
                          moreStatus: '',
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.headacheType,
                          text: Constant.headacheType,
                          moreStatus: '',
                          isShowDivider: false,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        MoreSection(
                          currentTag: Constant.myTriggers,
                          text: Constant.myTriggers,
                          moreStatus: '',
                          isShowDivider: true,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                        MoreSection(
                          currentTag: Constant.myMedications,
                          text: Constant.myMedications,
                          moreStatus: '',
                          isShowDivider: false,
                          navigateToOtherScreenCallback: _navigateToOtherScreen,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
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
