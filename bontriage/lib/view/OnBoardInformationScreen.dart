import 'package:flutter/material.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChatBubbleRightPointed.dart';
import '../util/PhotoHero.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardInformationScreen extends StatefulWidget {
  final bool isShowNextButton;
  final bool isSpannable;
  final List<TextSpan> bubbleChatTextSpanList;
  final String chatText;
  final String bottomButtonText;
  final Function nextButtonFunction;
  final Function bottomButtonFunction;
  final isShowSecondBottomButton;
  final String secondBottomButtonText;
  final Function secondBottomButtonFunction;
  final Function closeButtonFunction;
  final bool isShowCloseButton;

  const OnBoardInformationScreen(
      {Key key,
      this.isSpannable = false,
      this.bubbleChatTextSpanList,
      this.isShowNextButton,
      this.chatText,
      this.bottomButtonText,
      this.bottomButtonFunction,
      this.nextButtonFunction,
      this.isShowSecondBottomButton,
      this.secondBottomButtonText,
      this.secondBottomButtonFunction,
      this.closeButtonFunction,
      this.isShowCloseButton = true})
      : super(key: key);

  @override
  _OnBoardInformationScreenState createState() =>
      _OnBoardInformationScreenState();
}

class _OnBoardInformationScreenState extends State<OnBoardInformationScreen>
    with TickerProviderStateMixin {
  bool isVolumeOn = true;
  AnimationController _animationController;

  ///Method to toggle volume on or off
  void _toggleVolume() {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(Constant.chatBubbleVolumeState, isVolumeOn);
      TextToSpeechRecognition.pauseSpeechToText(widget.chatText);
      isVolumeOn = !isVolumeOn;
      prefs.setBool(Constant.chatBubbleVolumeState, isVolumeOn);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animationController.forward();
    TextToSpeechRecognition.speechToText(widget.chatText);
  }

  @override
  void didUpdateWidget(OnBoardInformationScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
/*    TextToSpeechRecognition.flutterTts.setStartHandler(() {

    });*/
    TextToSpeechRecognition.speechToText(widget.chatText);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: widget.isShowCloseButton,
                    child: GestureDetector(
                      onTap: widget.closeButtonFunction,
                      child: Image(
                        image: AssetImage(Constant.closeIcon),
                        width: 26,
                        height: 26,
                      ),
                    ),
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
                          image: AssetImage(Constant.volumeOn),
                          width: 20,
                          height: 20,
                        ),
                        secondChild: Image(
                          image: AssetImage(Constant.volumeOff),
                          width: 20,
                          height: 20,
                        ),
                        crossFadeState: isVolumeOn
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: PhotoHero(
                      photo: Constant.userAvatar,
                      width: 90,
                    ),
                  ))),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: ChatBubbleRightPointed(
                  painter:
                      ChatBubbleRightPointedPainter(Constant.chatBubbleGreen),
                  child: AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: FadeTransition(
                          opacity: _animationController,
                          child: RichText(
                            text: TextSpan(
                              children: widget.bubbleChatTextSpanList,
                            ),
                          ),
                        )

                        /*Text(
                        widget.chatText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Constant.bubbleChatTextView,
                          fontFamily: Constant.jostBold,
                          height: 1.2,
                        ),
                      ),*/

                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              if (widget.isShowNextButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: widget.nextButtonFunction,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        decoration: BoxDecoration(
                          color: Constant.chatBubbleGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            Constant.next,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Expanded(
                child: Container(),
              ),
              if (!widget.isShowNextButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.bottomButtonFunction,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: Color(0xffafd794),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              widget.bottomButtonText,
                              style: TextStyle(
                                  color: Constant.bubbleChatTextView,
                                  fontSize: 15,
                                  fontFamily: Constant.jostMedium),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 14,
              ),
              if (widget.isShowSecondBottomButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.secondBottomButtonFunction,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.3, color: Constant.chatBubbleGreen),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              widget.secondBottomButtonText,
                              style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontSize: 15,
                                  fontFamily: Constant.jostMedium),
                            ),
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
    );
  }
}
