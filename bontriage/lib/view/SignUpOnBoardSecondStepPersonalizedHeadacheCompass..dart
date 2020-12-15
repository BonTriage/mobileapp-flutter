import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/constant.dart';

class SignUpOnBoardSecondStepPersonalizedHeadacheCompass
    extends StatefulWidget {
  @override
  _SignUpOnBoardSecondStepPersonalizedHeadacheCompassState createState() =>
      _SignUpOnBoardSecondStepPersonalizedHeadacheCompassState();
}

class _SignUpOnBoardSecondStepPersonalizedHeadacheCompassState
    extends State<SignUpOnBoardSecondStepPersonalizedHeadacheCompass> {
  bool darkMode = false;
  double numberOfFeatures = 4;
  double sliderValue = 1;
  int startingValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      // 5s over, navigate to a new page
      const oneSec = const Duration(milliseconds: 800);
      new Timer.periodic(oneSec, (Timer t) {
        if (startingValue == 1) {
          startingValue = 2;
          setState(() {
            sliderValue = 2;
            // numberOfFeatures = 4;
          });
        } else if (startingValue == 2) {
          sliderValue = 3;
          startingValue = 3;
          setState(() {
            //sliderValue = 3;
            // numberOfFeatures = 4;
          });
        } else if (startingValue == 3) {
          sliderValue = 4;
          startingValue = 4;
          setState(() {
            //  sliderValue = 4;
            // numberOfFeatures = 4;
          });
        } else if (startingValue == 4) {
          sliderValue = 5;
          startingValue = 5;
          setState(() {
            // sliderValue = 5;
            // numberOfFeatures = 4;
          });
        } else {
          t.cancel();
          Navigator.pushReplacementNamed(
              context, Constant.signUpSecondStepHeadacheResultRouter);
        }
      });
    });

    // Save User Progress
    saveUserProgressInDataBase();
  }

  @override
  Widget build(BuildContext context) {
    const ticks = [7, 14, 21, 28, 35];
    var features = [
      "A",
      "B",
      "C",
      "D",
    ];
    var data = [
      [7, 7, 7, 7],
      [9, 10, 12, 14]
    ];
    var data1 = [
      [7, 10, 17, 27],
      [9, 15, 19, 23]
    ];
    var data2 = [
      [7, 14, 30, 7],
      [9, 10, 12, 14]
    ];
    var data3 = [
      [7, 17, 27, 7],
      [9, 10, 12, 14]
    ];

    features = features.sublist(0, numberOfFeatures.floor());
    if (sliderValue.round() == 1) {
      data = data
          .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
          .toList();
    } else if (sliderValue.round() == 2) {
      data1 = data1
          .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
          .toList();
      data = data1;
    } else if (sliderValue.round() == 3) {
      data2 = data2
          .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
          .toList();
      data = data2;
    } else if (sliderValue.round() == 4) {
      data3 = data3
          .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
          .toList();
      data = data3;
    } else if (sliderValue.round() == 5) {
      data = data
          .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
          .toList();
    }
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Container(
          decoration: Constant.backgroundBoxDecoration,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 120),
                  child: Text(
                    Constant.personalizedHeadacheCompass,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Constant.chatBubbleGreen,
                        fontSize: 16,
                        fontFamily: Constant.jostMedium),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: darkMode
                                ? RadarChart.dark(
                                    ticks: ticks,
                                    features: features,
                                    data: data,
                                    reverseAxis: true,
                                    compassValue: 0,
                                  )
                                : RadarChart.light(
                                    ticks: ticks,
                                    features: features,
                                    data: data,
                                    reverseAxis: true,
                                    compassValue: 0,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void saveUserProgressInDataBase() async{
    UserProgressDataModel userProgressDataModel = UserProgressDataModel();
    int userProgressDataCount = await SignUpOnBoardProviders.db
        .checkUserProgressDataAvailable(
        SignUpOnBoardProviders.TABLE_USER_PROGRESS);
    userProgressDataModel.userId = Constant.userID;
    userProgressDataModel.step = Constant.secondCompassEventStep;
    userProgressDataModel.userScreenPosition = 0;
    userProgressDataModel.questionTag = "";

    if (userProgressDataCount == 0) {
      SignUpOnBoardProviders.db.insertUserProgress(userProgressDataModel);
    } else {
      SignUpOnBoardProviders.db.updateUserProgress(userProgressDataModel);
    }
  }
}
