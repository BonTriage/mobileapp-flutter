import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';


class SignUpAgeScreen extends StatefulWidget {
  @override
  _SignUpAgeScreenState createState() => _SignUpAgeScreenState();
}

class _SignUpAgeScreenState extends State<SignUpAgeScreen> {
  double age = 3;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Slider(
              value: age,
              min: 3,
              max: 72,
              divisions: 69,
              onChanged: (double age) {
                setState(() {
                  this.age = age;
                });
              },
              activeColor: Constant.chatBubbleGreen,
              inactiveColor: Color(0xff434351),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3',
                    style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '72',
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
                  age.toInt().toString(),
                  style: TextStyle(
                    color: Constant.chatBubbleGreen,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'years old',
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
