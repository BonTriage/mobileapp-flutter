import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';

class SignUpAgeScreen extends StatefulWidget {
  double sliderValue;
  final double sliderMinValue;
  final double sliderMaxValue;
  final String minText;
  final String maxText;
  final String minTextLabel;
  final String maxTextLabel;
  final String labelText;
  final double horizontalPadding;
  final bool isAnimate;
  final String currentTag;
  final Function(String, String) selectedAnswerCallBack;
  final List<SelectedAnswers> selectedAnswerListData;
  final Function(String, String) onValueChangeCallback;
  final String uiHints;

  SignUpAgeScreen(
      {Key key,
      this.sliderValue,
      this.sliderMinValue,
      this.sliderMaxValue,
      this.labelText,
      this.minText,
      this.maxText,
      this.minTextLabel,
      this.maxTextLabel,
      this.horizontalPadding,
      this.isAnimate = true,
      this.currentTag,
      this.selectedAnswerListData,
      this.selectedAnswerCallBack,
      this.onValueChangeCallback,
      this.uiHints})
      : super(key: key);

  @override
  _SignUpAgeScreenState createState() => _SignUpAgeScreenState();
}

class _SignUpAgeScreenState extends State<SignUpAgeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  SelectedAnswers selectedAnswers;
  double sliderValue;

  String _minText = '';
  String _maxText = '';
  String _minLabel = '';
  String _maxLabel = '';
  String _label = '';

  @override
  void initState() {
    super.initState();

    sliderValue = widget.sliderValue;

    _animationController = AnimationController(
        duration: Duration(milliseconds: widget.isAnimate ? 800 : 0),
        vsync: this);

    _animationController.forward();

    if (widget.selectedAnswerListData != null) {
      selectedAnswers = widget.selectedAnswerListData.firstWhere(
          (model) => model.questionTag == widget.currentTag,
          orElse: () => null);
      if (selectedAnswers != null) {
        String selectedValue = selectedAnswers.answer;
        try {
          widget.sliderValue = double.parse(selectedValue);
          sliderValue = widget.sliderValue;
        } catch (e) {
          e.toString();
        }
      }
    }
    if (widget.selectedAnswerCallBack != null && widget.isAnimate)
      widget.selectedAnswerCallBack(
          widget.currentTag, widget.sliderValue.toInt().toString());

    _minText = widget.sliderMinValue.toInt().toString();
    _maxText = widget.sliderMaxValue.toInt().toString();
    _initLabelValues();
  }

  @override
  void didUpdateWidget(SignUpAgeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
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
            padding: EdgeInsets.symmetric(
                horizontal: (widget.horizontalPadding == null)
                    ? 15
                    : widget.horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: (widget.horizontalPadding == null) ? 0 : 15,
                ),
                Container(
                  child: Center(
                    child: Wrap(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Constant.sliderTrackColor,
                            inactiveTrackColor: Constant.sliderTrackColor,
                            thumbColor: Constant.chatBubbleGreen,
                            overlayColor: Constant.chatBubbleGreenTransparent,
                            trackHeight: 7,
                          ),
                          child: Slider(
                            value: widget.sliderValue,
                            min: widget.sliderMinValue,
                            max: widget.sliderMaxValue,
                            onChangeEnd: (age) {
                              //   if(!widget.isAnimate)
                              widget.sliderValue = age;
                              sliderValue = age.roundToDouble();
                              if(widget.selectedAnswerCallBack != null)
                                widget.selectedAnswerCallBack(widget.currentTag, sliderValue.ceil().toInt().toString());
                            },
                            onChanged: (double age) {
                              setState(() {
                                widget.sliderValue = age;
                                sliderValue = widget.sliderValue.roundToDouble();
                                if (widget.onValueChangeCallback != null)
                                  widget.onValueChangeCallback(
                                      widget.currentTag,
                                      sliderValue.toInt().toString());
                              });
                            },
                          ),
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _minText,
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        style: TextStyle(
                                          color: Constant.chatBubbleGreen,
                                          fontFamily: Constant.jostMedium,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        _minLabel,
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        textAlign: TextAlign.left,
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
                                        _maxText,
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        style: TextStyle(
                                          color: Constant.chatBubbleGreen,
                                          fontFamily: Constant.jostMedium,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        _maxLabel,
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        textAlign: TextAlign.right,
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Constant.chatBubbleGreenBlue),
                                    child: Center(
                                      child: Text(
                                        sliderValue.toInt().toString(),
                                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                        style: TextStyle(
                                          color: Constant.chatBubbleGreen,
                                          fontFamily: Constant.jostMedium,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _label,
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initLabelValues() {
    List<String> uiHintsSplitList = widget.uiHints.split(';');
    uiHintsSplitList.forEach((uiHintsElement) {
      List<String> labelSplitList = uiHintsElement.split('=');
      if(labelSplitList.length == 2) {
        labelSplitList[1] = labelSplitList[1].replaceAll('\\n', '\n');
        switch (labelSplitList[0]) {
          case Constant.minLabel1:
            _minLabel = labelSplitList[1];
            break;
          case Constant.maxLabel1:
            _maxLabel = labelSplitList[1];
            break;
          case Constant.minLabel:
            _minLabel = labelSplitList[1];
            break;
          case Constant.maxLabel:
            _maxLabel = labelSplitList[1];
            break;
          case Constant.minText:
            _minText = labelSplitList[1];
            break;
          case Constant.maxText:
            _maxText = labelSplitList[1];
            break;
          case Constant.label:
            _label = labelSplitList[1];
            break;
        }
      }
    });
  }
}
