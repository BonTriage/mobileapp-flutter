import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';


class SignUpAgeScreen extends StatefulWidget {
  double sliderValue = 3;
  double sliderMinValue = 3;
  double sliderMaxValue = 72;
  String minText = '';
  String maxText = '';
  String labelText = '';

  SignUpAgeScreen({Key key, this.sliderValue, this.sliderMinValue, this.sliderMaxValue, this.labelText, this.minText, this.maxText})  : super(key: key);

  @override
  _SignUpAgeScreenState createState() => _SignUpAgeScreenState();
}

class _SignUpAgeScreenState extends State<SignUpAgeScreen> with SingleTickerProviderStateMixin {

  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(SignUpAgeScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 40,),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Color(0xff434351),
                    inactiveTrackColor: Color(0xff434351),
                    thumbColor: Constant.chatBubbleGreen,
                    overlayColor: Constant.chatBubbleGreenTransparent,
                    trackHeight: 7
                  ),
                  child: Slider(
                    value: widget.sliderValue,
                    min: widget.sliderMinValue,
                    max: widget.sliderMaxValue,
                    onChanged: (double age) {
                      setState(() {
                        widget.sliderValue = age;
                      });
                    },
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.minText,
                                style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostMedium,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text(
                                'MIN',
                                style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostRegular,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.maxText,
                                style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostMedium,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text(
                                'MAX',
                                style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostRegular,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(height: 15,),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constant.chatBubbleGreenBlue
                            ),
                            child: Center(
                              child: Text(
                                widget.sliderValue.toInt().toString(),
                                style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostMedium,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            '${widget.labelText}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Constant.chatBubbleGreen,
                              fontFamily: Constant.jostMedium,
                            ),
                          ),
                        ],
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
}
