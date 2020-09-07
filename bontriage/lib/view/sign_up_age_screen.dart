import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';


class SignUpAgeScreen extends StatefulWidget {
  double sliderValue = 3;
  double sliderMinValue = 3;
  double sliderMaxValue = 72;
  String labelText = '';

  SignUpAgeScreen({this.sliderValue, this.sliderMinValue, this.sliderMaxValue, this.labelText});

  @override
  _SignUpAgeScreenState createState() => _SignUpAgeScreenState(sliderValue: sliderValue, sliderMinValue: sliderMinValue, sliderMaxValue: sliderMaxValue, labelText: labelText);
}

class _SignUpAgeScreenState extends State<SignUpAgeScreen> {

  double sliderValue = 3;
  double sliderMinValue = 3;
  double sliderMaxValue = 72;
  String labelText = '';

  _SignUpAgeScreenState({this.sliderValue, this.sliderMinValue, this.sliderMaxValue, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Color(0xff434351),
                inactiveTrackColor: Color(0xff434351),
                thumbColor: Constant.chatBubbleGreen,
                overlayColor: Constant.chatBubbleGreenTransparent,
                trackHeight: 7
              ),
              child: Slider(
                value: sliderValue,
                min: sliderMinValue,
                max: sliderMaxValue,
                onChanged: (double age) {
                  setState(() {
                    sliderValue = age;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sliderMinValue.toInt()}',
                    style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${sliderMaxValue.toInt()}',
                    style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constant.chatBubbleGreenBlue
              ),
              child: Center(
                child: Text(
                  sliderValue.toInt().toString(),
                  style: TextStyle(
                    color: Constant.chatBubbleGreen,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              '$labelText',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'FuturaMaxiLight',
                color: Constant.chatBubbleGreen,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
