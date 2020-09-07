import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChatBubbleLeftPointed.dart';

import 'ChatBubble.dart';
import 'ChatBubbleRightPointed.dart';

class SignUpFirstStepCompassResult extends StatefulWidget {
  @override
  _SignUpFirstStepCompassResultState createState() =>
      _SignUpFirstStepCompassResultState();
}

class _SignUpFirstStepCompassResultState
    extends State<SignUpFirstStepCompassResult> {
  bool darkMode = false;
  double numberOfFeatures = 4;
  double sliderValue = 1;

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
      [9, 15, 7, 7]
    ];

    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage(Constant.closeIcon),
                    width: 26,
                    height: 26,
                  ),
                ],
              ),
              SizedBox(height: 10),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage(Constant.userAvatar),
                          width: 35.0,
                          height: 35.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Image(
                            alignment: Alignment.topLeft,
                            image: AssetImage(Constant.volumeOn),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: ChatBubble(
                      painter: ChatBubblePaint(Constant.chatBubbleGreen),
                      child: Container(
                        child: Text(
                          Constant.compassDiagramTextView,
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: "FuturaMaxiLight",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "Frequency",
                        style: TextStyle(
                            color: Color(0xffafd794),
                            fontSize: 14,
                            fontFamily: "FuturaMaxiLight",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Intensity",
                          style: TextStyle(
                              color: Color(0xffafd794),
                              fontSize: 14,
                              fontFamily: "FuturaMaxiLight",
                              fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: Container(
                            width: 220,
                            height: 220,
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
                                      isPersonalizedHeadacheData: false,
                                          )
                                        : RadarChart.light(
                                            ticks: ticks,
                                            features: features,
                                            data: data,
                                            reverseAxis: true,
                                      isPersonalizedHeadacheData: false,
                                          ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Text(
                                          '70',
                                          style: TextStyle(
                                              color: Color(0xff0E1712),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffB8FFFF),
                                        border: Border.all(
                                            color: Color(0xffB8FFFF),
                                            width: 1.2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Disability",
                          style: TextStyle(
                              color: Color(0xffafd794),
                              fontSize: 14,
                              fontFamily: "FuturaMaxiLight",
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        "Duration",
                        style: TextStyle(
                            color: Color(0xffafd794),
                            fontSize: 14,
                            fontFamily: "FuturaMaxiLight",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BouncingWidget(
                      duration: Duration(milliseconds: 100),
                      scaleFactor: 1.5,
                      onPressed: () {
                        setState(() {
                          /*if (_progressPercent > 0.1) {
                                _progressPercent -= 0.11;
                              } else {
                                _progressPercent = 0;
                              }*/
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xffafd794),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            Constant.back,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 13,
                                fontFamily: "FuturaMaxiLight",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    BouncingWidget(
                      duration: Duration(milliseconds: 100),
                      scaleFactor: 1.5,
                      onPressed: () {
                        setState(() {});
                      },
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xffafd794),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            Constant.next,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 13,
                                fontFamily: "FuturaMaxiLight",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
