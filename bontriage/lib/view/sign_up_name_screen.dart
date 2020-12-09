import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpNameScreen extends StatefulWidget {
  final String tag;
  final String helpText;
  final Function(String, String) selectedAnswerCallBack;
  final List<SelectedAnswers> selectedAnswerListData;

  const SignUpNameScreen(
      {Key key,
      this.tag,
      this.helpText,
      this.selectedAnswerListData,
      this.selectedAnswerCallBack})
      : super(key: key);

  @override
  _SignUpNameScreenState createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  TextEditingController textEditingController;
  SelectedAnswers selectedAnswers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = TextEditingController();

    if (widget.selectedAnswerListData != null) {
      selectedAnswers = widget.selectedAnswerListData.firstWhere(
          (model) => model.questionTag == widget.tag,
          orElse: () => null);
      if (selectedAnswers != null) {
        textEditingController.text = selectedAnswers.answer;

      }
    }
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animationController.forward();

    textEditingController.addListener(_printLatestValue);
  }

  @override
  void didUpdateWidget(SignUpNameScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  _printLatestValue() {
    print("Second text field: ${textEditingController.text}");
  }

  @override
  void dispose() {
    widget.selectedAnswerCallBack(widget.tag, textEditingController.text);
    if (widget.tag == "nameClinicalImpression") {
      setHeadacheName(textEditingController.text);
    }
    _animationController.dispose();
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.fromLTRB(Constant.chatBubbleHorizontalPadding, 0,
            Constant.chatBubbleHorizontalPadding, 50),
        child: Center(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            onEditingComplete: () {
              widget.selectedAnswerCallBack(
                  widget.tag, textEditingController.text);
            },
            onSubmitted: (String value) {
              widget.selectedAnswerCallBack(widget.tag, value);
              FocusScope.of(context).requestFocus(FocusNode());
            },
            controller: textEditingController,
            onChanged: (String value) {
              widget.selectedAnswerCallBack(widget.tag, value);
              //print(value);
            },
            style: TextStyle(
                color: Constant.chatBubbleGreen,
                fontSize: 15,
                fontFamily: Constant.jostMedium),
            cursorColor: Constant.chatBubbleGreen,
            decoration: InputDecoration(
              hintText: 'Tap to Type',
              hintStyle: TextStyle(
                  color: Color.fromARGB(50, 175, 215, 148),
                  fontSize: 15,
                  fontFamily: Constant.jostMedium),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constant.chatBubbleGreen)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constant.chatBubbleGreen)),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          ),
        ),
      ),
    );
  }

  void setHeadacheName(String text) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constant.userHeadacheName, text);
  }
}
