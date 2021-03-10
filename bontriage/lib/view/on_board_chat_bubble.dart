import 'package:flutter/material.dart';
import 'package:mobile/util/TextToSpeechRecognition.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChatBubbleLeftPointed.dart';
import 'package:mobile/view/CustomScrollBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/PhotoHero.dart';

class OnBoardChatBubble extends StatefulWidget {
  final String chatBubbleText;
  final Color chatBubbleColor;
  final bool isEndOfOnBoard;
  final bool isShowCrossButton;
  final bool isSpannable;
  final List<TextSpan> textSpanList;
  final Function closeButtonFunction;

  const OnBoardChatBubble(
      {Key key,
      this.chatBubbleText,
      this.isEndOfOnBoard = false,
      this.chatBubbleColor,
      this.isShowCrossButton = true,
      this.isSpannable = false,
      this.textSpanList,
      this.closeButtonFunction})
      : super(key: key);

  @override
  _OnBoardChatBubbleState createState() => _OnBoardChatBubbleState();
}

class _OnBoardChatBubbleState extends State<OnBoardChatBubble>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool isVolumeOn = false;
  AnimationController _animationController;
  ScrollController _scrollController;

  ///Method to toggle volume on or off
  void _toggleVolume() async {
    setState(() {
      isVolumeOn = !isVolumeOn;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constant.chatBubbleVolumeState, isVolumeOn);
    TextToSpeechRecognition.speechToText(widget.chatBubbleText);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);

    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animationController.forward();
    setVolumeIcon();
    if (!widget.isEndOfOnBoard)
      TextToSpeechRecognition.speechToText(widget.chatBubbleText);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.detached || state == AppLifecycleState.inactive){
      TextToSpeechRecognition.stopSpeech();
    }else if(state == AppLifecycleState.resumed){
      TextToSpeechRecognition.speechToText(widget.chatBubbleText);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(OnBoardChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
    if (!widget.isEndOfOnBoard) {
      if (isVolumeOn)
        TextToSpeechRecognition.speechToText(widget.chatBubbleText);
    }

    try {
      _scrollController.animateTo(1, duration: Duration(milliseconds: 150), curve: Curves.easeIn);
      Future.delayed(Duration(milliseconds: 150), () {
        _scrollController.jumpTo(0);
      });
    } catch(e) {}
  }

  Widget _getTextWidget() {
    if (widget.isSpannable) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: Constant.chatBubbleMaxHeight,
        ),
        child: CustomScrollBar(
          controller: _scrollController,
          isAlwaysShown: false,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
              text: TextSpan(
                children: widget.textSpanList,
              ),
            ),
          ),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: Constant.chatBubbleMaxHeight,
        ),
        child: CustomScrollBar(
          controller: _scrollController,
          isAlwaysShown: false,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: Text(
              widget.chatBubbleText,
              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
              style: TextStyle(
                fontSize: 16,
                fontFamily: Constant.jostRegular,
                height: 1.3,
                color: (widget.chatBubbleColor == null)
                    ? Constant.chatBubbleGreen
                    : Constant.bubbleChatTextView,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: widget.isShowCrossButton,
            child: Container(
              padding: EdgeInsets.fromLTRB(Constant.chatBubbleHorizontalPadding,
                  20, Constant.chatBubbleHorizontalPadding, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: widget.closeButtonFunction,
                    child: Image(
                      image: AssetImage(Constant.closeIcon),
                      width: 26,
                      height: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.chatBubbleHorizontalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhotoHero(
                  photo: Constant.userAvatar,
                  width: 60,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.chatBubbleHorizontalPadding),
            child: ChatBubbleLeftPointed(
              painter: ChatBubblePainter((widget.chatBubbleColor == null)
                  ? Constant.oliveGreen
                  : widget.chatBubbleColor),
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: _getTextWidget(),
                  ),
                ),
              ),
            ),
          ),
        ],
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
