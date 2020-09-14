import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChatBubbleLeftPointed.dart';

class OnBoardChatBubble extends StatefulWidget {
  final String chatBubbleText;
  final Color chatBubbleColor;

  const OnBoardChatBubble({Key key, this.chatBubbleText, this.chatBubbleColor}) : super(key: key);

  @override
  _OnBoardChatBubbleState createState() => _OnBoardChatBubbleState();
}

class _OnBoardChatBubbleState extends State<OnBoardChatBubble> with TickerProviderStateMixin {
  bool isVolumeOn = true;

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(OnBoardChatBubble oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(Constant.userAvatar),
                  width: 50,
                  height: 50,
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ChatBubbleLeftPointed(
              painter: ChatBubblePainter((widget.chatBubbleColor == null) ? Constant.chatBubbleGreenBlue : widget.chatBubbleColor),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  widget.chatBubbleText,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: (widget.chatBubbleColor == null) ? Constant.chatBubbleGreen : Constant.bubbleChatTextView,
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
