import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class SignUpNameScreen extends StatefulWidget {
  @override
  _SignUpNameScreenState createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(SignUpNameScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.fromLTRB(Constant.chatBubbleHorizontalPadding, 0,
            Constant.chatBubbleHorizontalPadding, 50),
        child: Center(
          child: TextField(
            style: TextStyle(
                color: Constant.chatBubbleGreen,
                fontSize: 15,
                fontFamily: Constant.jostMedium),
            cursorColor: Constant.chatBubbleGreen,
            decoration: InputDecoration(
              hintText: Constant.nameHint,
              hintStyle: TextStyle(
                  color: Color.fromARGB(50, 175, 215, 148),
                  fontSize: 15,
                  fontFamily: Constant.jostMedium),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constant.chatBubbleGreen)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constant.chatBubbleGreen)),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          ),
        ),
      ),
    );
  }
}
