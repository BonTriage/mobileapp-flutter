import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';


class SignUpAgeScreen extends StatefulWidget {
  double sliderValue = 3;
  double sliderMinValue = 3;
  double sliderMaxValue = 72;
  String minText = '';
  String maxText = '';
  String labelText = '';

  SignUpAgeScreen({Key key, this.sliderValue, this.sliderMinValue, this.sliderMaxValue, this.labelText, this.minText, this.maxText})  : super(key: key);

  @override
  _SignUpAgeScreenState createState() => _SignUpAgeScreenState();
}

class _SignUpAgeScreenState extends State<SignUpAgeScreen> {

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
                value: widget.sliderValue,
                min: widget.sliderMinValue,
                max: widget.sliderMaxValue,
                onChanged: (double age) {
                  setState(() {
                    widget.sliderValue = age;
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
                    widget.minText,
                    style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.maxText,
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
                  widget.sliderValue.toInt().toString(),
                  style: TextStyle(
                    color: Constant.chatBubbleGreen,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              '${widget.labelText}',
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
