import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChatBubbleRightPointed.dart';

class OnBoardInformationScreen extends StatefulWidget {
  final bool isShowNextButton;
  final String chatText;
  final String bottomButtonText;
  final Function nextButtonFunction;
  final Function bottomButtonFunction;

  const OnBoardInformationScreen(
      {Key key, this.isShowNextButton, this.chatText, this.bottomButtonText, this.bottomButtonFunction, this.nextButtonFunction})
      : super(key: key);

  @override
  _OnBoardInformationScreenState createState() =>
      _OnBoardInformationScreenState();
}

class _OnBoardInformationScreenState extends State<OnBoardInformationScreen> {
  bool isVolumeOn = true;

  ///Method to toggle volume on or off
  void _toggleVolume() {
    setState(() {
      isVolumeOn = !isVolumeOn;
    });
  }

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
                      child: GestureDetector(
                        onTap: _toggleVolume,
                        child: AnimatedCrossFade(
                          duration: Duration(milliseconds: 250),
                          firstChild: Image(
                            image: AssetImage(
                                Constant.volumeOn),
                            width: 20,
                            height: 20,
                          ),
                          secondChild: Image(
                            image: AssetImage(
                                Constant.volumeOff),
                            width: 20,
                            height: 20,
                          ),
                          crossFadeState: isVolumeOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Image.asset(
                                Constant.userAvatar,
                                width: 60,
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
                            fontFamily: "FuturaMaxiLight",
                            fontWeight: FontWeight.bold),
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
                    GestureDetector(
                      onTap: () {},
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
                                fontFamily: "FuturaMaxiLight",
                                fontWeight: FontWeight.bold),
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
