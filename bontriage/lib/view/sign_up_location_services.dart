import 'dart:convert';

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
  final Function(String) removeSelectedAnswerCallback;
  final List<SelectedAnswers> selectedAnswerListData;

  const SignUpLocationServices(
      {Key key,
      this.question,
      this.selectedAnswerCallBack,
      this.selectedAnswerListData,
      this.removeSelectedAnswerCallback})
      : super(key: key);

  @override
  _SignUpLocationServicesState createState() => _SignUpLocationServicesState();
}

class _SignUpLocationServicesState extends State<SignUpLocationServices>
    with SingleTickerProviderStateMixin {
  bool _locationServicesSwitchState;
  AnimationController _animationController;
  bool _isCheckingLocation;
  Position _position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _locationServicesSwitchState = false;
    _isCheckingLocation = false;

    _animationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    _animationController.forward();

    if (widget.selectedAnswerListData != null) {
      SelectedAnswers selectedAnswers = widget.selectedAnswerListData.firstWhere((model) => model.questionTag == widget.question.tag, orElse: () => null);

      if(selectedAnswers != null) {
        _locationServicesSwitchState = selectedAnswers.answer.isNotEmpty;
      } else {
        widget.selectedAnswerCallBack(widget.question.tag, Constant.blankString);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocationPosition();
    });
  }

  @override
  void didUpdateWidget(SignUpLocationServices oldWidget) {
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
                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                  style: TextStyle(
                    fontSize: 16,
                    color: Constant.chatBubbleGreen,
                    fontFamily: Constant.jostMedium,
                  ),
                ),
                CupertinoSwitch(
                  value: _locationServicesSwitchState,
                  onChanged: (bool state) {
                    if (state) {
                      _checkLocationPermission();
                    } else {
                      setState(() {
                        _locationServicesSwitchState = state;
                        /*widget.selectedAnswerCallBack(widget.question.tag,
                              _locationServicesSwitchState.toString());*/
                        widget.removeSelectedAnswerCallback(widget.question.tag);
                      });
                    }
                  },
                  activeColor: Constant.chatBubbleGreen.withOpacity(0.6),
                  trackColor: Constant.chatBubbleGreen.withOpacity(0.2),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              Constant.enableLocationRecommended,
              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
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

  Future<void> _checkLocationPermission() async {
    if(_position == null)
      _position = await Utils.determinePosition();

    if(_position != null) {
      setState(() {
        _locationServicesSwitchState = true;
      });
      List<String> latLngList = [];
      latLngList.add(_position.latitude.toString());
      latLngList.add(_position.longitude.toString());
      widget.selectedAnswerCallBack(widget.question.tag, jsonEncode(latLngList));
    } else {
      var result = await Utils.showConfirmationDialog(context, 'You haven\'t allowed Location permissions to BonTriage. If you want to access Location, please grant permission.','Permission Required!','Not now','Allow');
      if(result == 'Yes'){
        Geolocator.openAppSettings();
      }
    }
  }

  void _getLocationPosition() async {
    Position position = await Utils.determinePosition();
    print('Position????$position');
    _position = position;
  }
}
