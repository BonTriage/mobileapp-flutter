import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChatBubbleLeftPointed.dart';

import '../util/PhotoHero.dart';

class OnBoardChatBubble extends StatefulWidget {
  final String chatBubbleText;
  final Color chatBubbleColor;

  const OnBoardChatBubble({Key key, this.chatBubbleText, this.chatBubbleColor}) : super(key: key);

  @override
  _OnBoardChatBubbleState createState() => _OnBoardChatBubbleState();
}

class _OnBoardChatBubbleState extends State<OnBoardChatBubble> with TickerProviderStateMixin {
  bool isVolumeOn = true;
  AnimationController _animationController;

  ///Method to toggle volume on or off
  void _toggleVolume() {
    setState(() {
      isVolumeOn = !isVolumeOn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(OnBoardChatBubble oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(Constant.chatBubbleHorizontalPadding, 20, Constant.chatBubbleHorizontalPadding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image(
                  image: AssetImage(Constant.closeIcon),
                  width: 26,
                  height: 26,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Constant.chatBubbleHorizontalPadding),
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Constant.chatBubbleHorizontalPadding),
            child: ChatBubbleLeftPointed(

              painter: ChatBubblePainter((widget.chatBubbleColor == null) ? Constant.oliveGreen
                  : widget.chatBubbleColor),

              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Text(
                      widget.chatBubbleText,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constant.jostRegular,
                          height: 1.3,
                          color: (widget.chatBubbleColor == null) ? Constant.chatBubbleGreen : Constant.bubbleChatTextView,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
