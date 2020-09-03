import 'package:flutter/material.dart';
import 'package:mobile/util/RadarChart.dart';
import 'package:mobile/util/constant.dart';

class SignUpFirstStepCompassResult extends StatefulWidget {
  @override
  _SignUpFirstStepCompassResultState createState() =>
      _SignUpFirstStepCompassResultState();
}

class _SignUpFirstStepCompassResultState extends State<SignUpFirstStepCompassResult> {
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
      [7, 7, 7, 7],
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

    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        height: MediaQuery.of(context).size.height,
        child: Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RotatedBox(
                  quarterTurns: 3,
                  child: Text("Intensity",
                    style: TextStyle(
                      color:Color(0xffafd794),
                      fontSize: 16,
                    ),),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("Frequency",
                      style: TextStyle(
                        color:Color(0xffafd794),
                        fontSize: 16,
                      ),),
                    Container(
                      width: 220,
                      height: 220,
                      child: darkMode
                          ? RadarChart.dark(
                        ticks: ticks,
                        features: features,
                        data: data,
                        reverseAxis: true,
                      )
                          : RadarChart.light(
                        ticks: ticks,
                        features: features,
                        data: data,
                        reverseAxis: true,
                      ),
                    ),
                    Text("Disability",
                      style: TextStyle(
                        color:Color(0xffafd794),
                        fontSize: 16,
                      ),),
                  ],
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text("Duration",
                    style: TextStyle(
                      color:Color(0xffafd794),
                      fontSize: 16,
                    ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
