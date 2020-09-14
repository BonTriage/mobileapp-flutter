import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/on_board_chat_bubble.dart';

class OnBoardHeadacheNameScreen extends StatefulWidget {
  @override
  _OnBoardHeadacheNameScreenState createState() => _OnBoardHeadacheNameScreenState();
}

class _OnBoardHeadacheNameScreenState extends State<OnBoardHeadacheNameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OnBoardChatBubble(
              chatBubbleText: "_questionList[_currentPageIndex]",
              chatBubbleColor: Constant.chatBubbleGreen,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
