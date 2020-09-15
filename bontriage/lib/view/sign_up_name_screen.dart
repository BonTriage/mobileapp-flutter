import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class SignUpNameScreen extends StatefulWidget {
  @override
  _SignUpNameScreenState createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
      child: Center(
        child: TextField(
          style: TextStyle(color: Constant.chatBubbleGreen, fontSize: 15),
          cursorColor: Constant.chatBubbleGreen,
          decoration: InputDecoration(
            hintText: Constant.nameHint,
            hintStyle: TextStyle(
              color: Color.fromARGB(50, 175, 215, 148),
              fontSize: 15,
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Constant.chatBubbleGreen)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Constant.chatBubbleGreen)),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          ),
        ),
      ),
    );
  }
}
