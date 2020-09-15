import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

import 'ChatBubbleRightPointed.dart';

class SignUpOnBoardStartAssessment extends StatefulWidget {
  @override
  _StateSignUpOnBoardStartAssessment createState() =>
      _StateSignUpOnBoardStartAssessment();
}

class _StateSignUpOnBoardStartAssessment
    extends State<SignUpOnBoardStartAssessment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                SizedBox(
                  height: 80,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Image.asset(
                        Constant.volumeOn,
                        width: 20,
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Image.asset(
                        Constant.userAvatar,
                        width: 65,
                      ),
                    ))),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: ChatBubbleRightPointed(
                    painter:
                        ChatBubbleRightPointedPainter(Constant.chatBubbleGreen),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        Constant.letsStarted,
                        style: TextStyle(
                            fontSize: 14,
                            color: Constant.bubbleChatTextView,
                            fontFamily: Constant.jostBold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BouncingWidget(
                      duration: Duration(milliseconds: 100),
                      scaleFactor: 1.5,
                      onPressed: () {
                        {
                          Navigator.pushReplacementNamed(context,
                              Constant.signUpOnBoardHeadacheQuestionRouter);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffafd794),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            Constant.startAssessment,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 13.5,
                                fontFamily: Constant.jostBold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
