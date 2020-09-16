import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class OnBoardBottomButtons extends StatefulWidget {
  Function backButtonFunction;
  Function nextButtonFunction;
  double progressPercent;
  int onBoardPart;

  OnBoardBottomButtons({
    Key key,
    this.backButtonFunction,
    this.nextButtonFunction,
    this.progressPercent,
    this.onBoardPart
  }) : super(key: key);

  @override
  _OnBoardBottomButtonsState createState() => _OnBoardBottomButtonsState();
}

class _OnBoardBottomButtonsState extends State<OnBoardBottomButtons> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: Constant.chatBubbleHorizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                BouncingWidget(
                  duration: Duration(milliseconds: 100),
                  scaleFactor: 1.5,
                  onPressed: widget.backButtonFunction,
                  child: Container(
                    width: 130,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Color(0xffafd794),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        Constant.back,
                        style: TextStyle(
                            color: Constant.bubbleChatTextView,
                            fontSize: 15,
                            fontFamily: Constant.jostMedium),
                      ),
                    ),
                  ),
                ),
              BouncingWidget(
                duration: Duration(milliseconds: 100),
                scaleFactor: 1.5,
                onPressed: widget.nextButtonFunction,
                child: Container(
                  width: 130,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Color(0xffafd794),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      Constant.next,
                      style: TextStyle(
                          color: Constant.bubbleChatTextView,
                          fontSize: 15,
                          fontFamily: Constant.jostMedium),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 36,
        ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 8.0,
              animationDuration: 200,
              animateFromLastPercent: true,
              percent: widget.progressPercent,
              backgroundColor: Constant.chatBubbleGreenBlue,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Constant.chatBubbleGreen,
            ),
          ),
        SizedBox(
          height: 10.5,
        ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Constant.chatBubbleHorizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'PART ${widget.onBoardPart} OF 3',
                  style: TextStyle(
                      color: Constant.chatBubbleGreen, fontSize: 13,fontFamily: Constant.jostMedium),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 46,
        )
      ],
    );
  }
}
