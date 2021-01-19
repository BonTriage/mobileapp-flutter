import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class SignUpLocationServices extends StatefulWidget {
  final Questions question;
  final Function(String, String) selectedAnswerCallBack;
  final List<SelectedAnswers> selectedAnswerListData;

  const SignUpLocationServices(
      {Key key,
      this.question,
      this.selectedAnswerCallBack,
      this.selectedAnswerListData})
      : super(key: key);

  @override
  _SignUpLocationServicesState createState() => _SignUpLocationServicesState();
}

class _SignUpLocationServicesState extends State<SignUpLocationServices>
    with SingleTickerProviderStateMixin {
  bool _locationServicesSwitchState = false;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    _animationController.forward();

    if (widget.selectedAnswerListData != null) {
      SelectedAnswers selectedAnswers = widget.selectedAnswerListData.firstWhere((model) => model.questionTag == widget.question.tag, orElse: () => null);

      if(selectedAnswers != null) {
        _locationServicesSwitchState = selectedAnswers.answer.toLowerCase() == 'true';
      }
    }

    widget.selectedAnswerCallBack(
        widget.question.tag, _locationServicesSwitchState.toString());
  }

  @override
  void didUpdateWidget(SignUpLocationServices oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (!_animationController.isAnimating) {
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
        padding: EdgeInsets.symmetric(
            horizontal: Constant.chatBubbleHorizontalPadding),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Constant.enableLocationServices,
                  style: TextStyle(
                    fontSize: 16,
                    color: Constant.chatBubbleGreen,
                    fontFamily: Constant.jostMedium,
                  ),
                ),
                CupertinoSwitch(
                  value: _locationServicesSwitchState,
                  onChanged: (bool state) {
                    if(state == true) {
                      _checkLocationPermission();
                    } else {
                      setState(() {
                        _locationServicesSwitchState = state;
                        widget.selectedAnswerCallBack(widget.question.tag,
                            _locationServicesSwitchState.toString());
                        print(state);
                      });
                    }
                  },
                  activeColor: Constant.chatBubbleGreen.withOpacity(0.6),
                  trackColor: Constant.chatBubbleGreen.withOpacity(0.2),
                  /*activeTrackColor: Constant.chatBubbleGreen.withOpacity(0.6),
                  inactiveThumbColor: Constant.chatBubbleGreen,
                  inactiveTrackColor: Constant.chatBubbleGreenBlue,*/
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              Constant.enableLocationRecommended,
              style: TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  color: Constant.locationServiceGreen,
                  fontFamily: Constant.jostRegular),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLocationPermission() async{
    Position position = await Utils.determinePosition();

    if(position != null) {
      setState(() {
        _locationServicesSwitchState = true;
        widget.selectedAnswerCallBack(widget.question.tag,
            _locationServicesSwitchState.toString());
      });
    }
  }
}
