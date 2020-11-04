import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class MoreAgeScreen extends StatefulWidget {
  @override
  _MoreAgeScreenState createState() =>
      _MoreAgeScreenState();
}

class _MoreAgeScreenState
    extends State<MoreAgeScreen> {

  double _currentAgeValue = 3;

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
                            Constant.age,
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
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Constant.backgroundColor,
                      inactiveTrackColor: Constant.backgroundColor,
                      thumbColor: Constant.chatBubbleGreen,
                      overlayColor: Constant.chatBubbleGreenTransparent,
                      trackHeight: 7,
                    ),
                    child: Slider(
                      value: _currentAgeValue,
                      min: 3,
                      max: 72,
                      onChanged: (double age) {
                        setState(() {
                          _currentAgeValue = age;
                        });
                      },
                    ),
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '3',
                                  style: TextStyle(
                                    color: Constant.locationServiceGreen,
                                    fontFamily: Constant.jostMedium,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '72',
                                  style: TextStyle(
                                    color: Constant.locationServiceGreen,
                                    fontFamily: Constant.jostMedium,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(height: 15,),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constant.chatBubbleGreenBlue
                              ),
                              child: Center(
                                child: Text(
                                  _currentAgeValue.toInt().toString(),
                                  style: TextStyle(
                                    color: Constant.locationServiceGreen,
                                    fontFamily: Constant.jostMedium,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              Constant.yearsOld,
                              style: TextStyle(
                                fontSize: 15,
                                color: Constant.locationServiceGreen,
                                fontFamily: Constant.jostMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Constant.slideToEnterYourAge,
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontSize: 14,
                          fontFamily: Constant.jostMedium
                      ),
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
}
