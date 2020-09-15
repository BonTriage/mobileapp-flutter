import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

import '../util/constant.dart';

class WelcomeStartAssessmentScreen extends StatefulWidget {
  @override
  _WelcomeStartAssessmentScreenState createState() => _WelcomeStartAssessmentScreenState();
}

class _WelcomeStartAssessmentScreenState extends State<WelcomeStartAssessmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage(Constant.brain),
                      width: 56,
                      height: 50,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      Constant.migraineMentor,
                      style: TextStyle(
                        color: Constant.chatBubbleGreen,
                        fontSize: 22,
                        fontFamily: Constant.jostRegular,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Text(
                  Constant.conquerYourHeadaches,
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 18,
                      fontFamily: Constant.jostRegular,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  Constant.personalizedUnderstanding,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Constant.locationServiceGreen,
                    height: 1.3,
                    fontSize: 16,
                    fontFamily: Constant.jostRegular,
                  ),
                ),
                SizedBox(height: 100),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Constant.signUpOnBoardSplashRouter);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Constant.chatBubbleGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      Constant.startYourAssessment,
                      style: TextStyle(
                          color: Constant.bubbleChatTextView,
                          fontSize: 15,
                          fontFamily: Constant.jostMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constant.or,
                      style: TextStyle(
                        wordSpacing: 1,
                        color: Constant.chatBubbleGreen,
                        fontFamily: Constant.jostRegular,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        Constant.signIn,
                        style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontFamily: Constant.jostRegular,
                            wordSpacing: 1,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1
                        ),
                      ),
                    ),
                    Text(
                      Constant.toAn,
                      style: TextStyle(
                        color: Constant.chatBubbleGreen,
                        fontFamily: Constant.jostRegular,
                        fontSize: 13,
                        wordSpacing: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Text(
                  Constant.existingAccount,
                  style: TextStyle(
                    color: Constant.chatBubbleGreen,
                    fontFamily: Constant.jostRegular,
                    fontSize: 13,
                    wordSpacing: 1
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
