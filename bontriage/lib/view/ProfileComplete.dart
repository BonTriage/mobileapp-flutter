import 'package:flutter/material.dart';
import 'package:mobile/util/PhotoHero.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OnBoardInformationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChatBubbleRightPointed.dart';

class ProfileComplete extends StatefulWidget {
  @override
  _ProfileCompleteState createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete>
    with TickerProviderStateMixin {
  bool isVolumeOn = false;
  AnimationController _animationController;

  ///Method to toggle volume on or off
  void _toggleVolume() async {
    setState(() {
      isVolumeOn = !isVolumeOn;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constant.chatBubbleVolumeState, isVolumeOn);
    TextToSpeechRecognition.speechToText(Constant.profileCompleteTextView);
  }

  List<TextSpan> _spannableTextViewList = [
    TextSpan(
        text: Constant.profileCompleteThatNow,
        style: TextStyle(
            height: 1.3,
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            color: Constant.bubbleChatTextView)),
    TextSpan(
        text: ' MigraineMentor! ',
        style: TextStyle(
            height: 1.3,
            fontSize: 16,
            fontFamily: Constant.jostMedium,
            color: Constant.splashMigraineMentorTextColor)),
    TextSpan(
        text: Constant.profileCompleteCommentsSignedInfo,
        style: TextStyle(
            height: 1.3,
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            color: Constant.bubbleChatTextView))
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animationController.forward();
    TextToSpeechRecognition.speechToText(Constant.profileCompleteTextView);
    setVolumeIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Constant.thankYouProfile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 17,
                      fontFamily: Constant.jostMedium),
                ),
                SizedBox(height: 30),
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
                                children: _spannableTextViewList,
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
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, Constant.homeRouter, arguments: false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: Color(0xffafd794),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              Constant.finish,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setVolumeIcon() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isVolume = sharedPreferences.getBool(Constant.chatBubbleVolumeState);
    setState(() {
      if (isVolume == null || isVolume) {
        isVolumeOn = true;
      } else {
        isVolumeOn = false;
      }
    });
  }
}
