import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/on_board_chat_bubble.dart';

import '../util/constant.dart';

class OnBoardHeadacheNameScreen extends StatefulWidget {
  @override
  _OnBoardHeadacheNameScreenState createState() => _OnBoardHeadacheNameScreenState();
}

class _OnBoardHeadacheNameScreenState extends State<OnBoardHeadacheNameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Constant.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OnBoardChatBubble(
              chatBubbleText: Constant.greatWeAreDone,
              chatBubbleColor: Constant.chatBubbleGreen,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: TextField(
                  style: TextStyle(color: Constant.chatBubbleGreen, fontSize: 15),
                  cursorColor: Constant.chatBubbleGreen,
                  decoration: InputDecoration(
                    hintText: Constant.tapToType,
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
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BouncingWidget(
                    duration: Duration(milliseconds: 100),
                    scaleFactor: 1.5,
                    onPressed: () {},
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffafd794),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          Constant.back,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: Constant.futuraMaxiLight,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  BouncingWidget(
                    duration: Duration(milliseconds: 100),
                    scaleFactor: 1.5,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constant.signUpOnBoardSecondStepPersonalizedHeadacheResultRouter);
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffafd794),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          Constant.next,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: Constant.futuraMaxiLight,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 114.5,),
          ],
        ),
      ),
    );
  }
}
