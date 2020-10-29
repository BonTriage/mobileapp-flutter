import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreMyInfoScreen extends StatefulWidget {
  @override
  _MoreMyInfoScreenState createState() => _MoreMyInfoScreenState();
}

class _MoreMyInfoScreenState extends State<MoreMyInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
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
                                width: 20,
                                height: 20,
                                image: AssetImage(Constant.leftArrow),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                Constant.myInfo,
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
                              text: Constant.name,
                              moreStatus: Constant.lindaJones,
                              isShowDivider: true,
                            ),
                            MoreSection(
                              text: Constant.age,
                              moreStatus: Constant.twentyTwo,
                              isShowDivider: true,
                            ),
                            MoreSection(
                              text: Constant.gender,
                              moreStatus: Constant.female,
                              isShowDivider: true,
                            ),
                            MoreSection(
                              text: Constant.sex,
                              moreStatus: Constant.female,
                              isShowDivider: true,
                            ),
                            MoreSection(
                              text: Constant.homeLocation,
                              moreStatus: Constant.stanfordCA,
                              isShowDivider: true,
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
                                      fontFamily: Constant.jostMedium),
                                ),
                                Image(
                                  width: 20,
                                  height: 20,
                                  image: AssetImage(Constant.rightArrow),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
