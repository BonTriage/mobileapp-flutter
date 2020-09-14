import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Text(
                  Constant.conquerYourHeadaches,
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 16,
                      fontFamily: Constant.futuraMaxiLight,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  Constant.personalizedUnderstanding,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Constant.locationServiceGreen,
                    height: 1.7,
                    fontSize: 14,
                    fontFamily: Constant.futuraMaxiLight,
                  ),
                ),
                SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Constant.chatBubbleGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    Constant.startYourAssessment,
                    style: TextStyle(
                        color: Constant.bubbleChatTextView,
                        fontSize: 13,
                        fontFamily: Constant.futuraMaxiLight,
                        fontWeight: FontWeight.bold
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
                        fontFamily: Constant.futuraMaxiLight,
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        Constant.signIn,
                        style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontFamily: Constant.futuraMaxiLight,
                            wordSpacing: 1,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationThickness: 5
                        ),
                      ),
                    ),
                    Text(
                      Constant.toAn,
                      style: TextStyle(
                        color: Constant.chatBubbleGreen,
                        fontFamily: Constant.futuraMaxiLight,
                        fontSize: 13,
                        wordSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Text(
                  Constant.existingAccount,
                  style: TextStyle(
                    color: Constant.chatBubbleGreen,
                    fontFamily: Constant.futuraMaxiLight,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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
