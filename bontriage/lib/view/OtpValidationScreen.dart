import 'dart:async';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/blocs/OtpValidationBloc.dart';
import 'package:mobile/models/ForgotPasswordModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/ChangePasswordScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class OtpValidationScreen extends StatefulWidget {
  final OTPValidationArgumentModel otpValidationArgumentModel;

  const OtpValidationScreen({Key key, @required this.otpValidationArgumentModel}) : super(key: key);

  @override
  _OtpValidationScreenState createState() => _OtpValidationScreenState();
}

class _OtpValidationScreenState extends State<OtpValidationScreen> with SingleTickerProviderStateMixin {

  List<FocusNode> _focusNodeList;
  List<TextEditingController> _textEditingControllerList;
  OtpValidationBloc _bloc;

  Timer _timer;

  bool _isShowError = false;
  String _errorMessage = Constant.blankString;

  @override
  void initState() {
    super.initState();

    _bloc = OtpValidationBloc();

    _focusNodeList = [
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];

    _textEditingControllerList = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_focusNodeList[0]);

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        var otpTimerInfo = Provider.of<OTPTimerInfo>(context, listen: false);
        if(timer.tick == 30) {
          timer.cancel();
        }

        otpTimerInfo.updateTime(timer.tick);
      });
    });

    _listenToOtpVerifyStream();

    if(widget.otpValidationArgumentModel.isFromSignUp) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _bloc.callResendOTPApi(widget.otpValidationArgumentModel.email);
      });
    }
  }

  @override
  void dispose() {
    if(mounted) {
      _timer.cancel();
      _focusNodeList.forEach((element) {
        element.dispose();
      });

      _textEditingControllerList.forEach((element) {
        element.dispose();
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('otp validation build func');
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaleFactor: mediaQueryData.textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constant.backgroundColor,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image(
                        image: AssetImage(Constant.closeIcon),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Text(
                    'OTP Verification',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 18,
                      fontFamily: Constant.jostMedium,
                    ),
                  ),
                  SizedBox(height: 70,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Please type the OTP sent to ${widget.otpValidationArgumentModel.email}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _getTextFormField(0),
                          SizedBox(width: 15,),
                          _getTextFormField(1),
                          SizedBox(width: 15,),
                          _getTextFormField(2),
                          SizedBox(width: 15,),
                          _getTextFormField(3),
                        ],
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    vsync: this,
                    child: Consumer<OTPErrorInfo>(
                      builder: (context, otpErrorInfoData, child) {
                        return Visibility(
                          visible: otpErrorInfoData.isShowError(),
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.center,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Image(
                                    image: AssetImage(Constant.warningPink),
                                    width: 22,
                                    height: 22,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    otpErrorInfoData.getErrorMessage(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Constant.pinkTriggerColor,
                                        fontFamily: Constant.jostRegular),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30,),
                  Consumer<OTPTimerInfo>(
                    builder: (context, data, child) {
                      int seconds = data.getTime();
                      if(seconds == 30) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn\'t receive OTP? ',
                              style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 14,
                                fontFamily: Constant.jostRegular,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _onResendButtonClicked();
                              },
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  fontFamily: Constant.jostRegular,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Text(
                        'Resend OTP in ${_bloc.getFormattedTime(seconds)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontSize: 14,
                          fontFamily: Constant.jostRegular,
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BouncingWidget(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _onNextClicked();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Constant.chatBubbleGreen,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              Constant.next,
                              style: TextStyle(
                                  color:
                                  Constant.bubbleChatTextView,
                                  fontSize: 15,
                                  fontFamily:
                                  Constant.jostMedium),
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
      ),
    );
  }

  Container _getTextFormField(int index) {
    return Container(
      width: 40,
      child: TextFormField(
        focusNode: _focusNodeList[index],
        controller: _textEditingControllerList[index],
        maxLength: 1,
        onChanged: (text) {
          print('on text changed');
          if(text.isEmpty) {
            if(index != 0)
              FocusScope.of(context).requestFocus(_focusNodeList[index - 1]);
          } else {
            if(index != 3 && text.isNotEmpty)
              FocusScope.of(context).requestFocus(_focusNodeList[index + 1]);
          }
        },
        style: TextStyle(
            fontSize: 16,
            color: Constant.chatBubbleGreen,
            fontFamily: Constant.jostMedium
        ),
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Constant.chatBubbleGreen)
          ),
          counterText: Constant.blankString,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Constant.chatBubbleGreen)
          ),
        ),
      ),
    );
  }

  void _onNextClicked() {
    String otp1 = _textEditingControllerList[0].text ?? Constant.blankString;
    String otp2 = _textEditingControllerList[1].text ?? Constant.blankString;
    String otp3 = _textEditingControllerList[2].text ?? Constant.blankString;
    String otp4 = _textEditingControllerList[3].text ?? Constant.blankString;

    String otp = '$otp1$otp2$otp3$otp4';

    var otpErrorInfoData = Provider.of<OTPErrorInfo>(context, listen: false);

    if(otp.isEmpty) {
      otpErrorInfoData.updateOtpErrorInfoData(true, 'Please provide the valid OTP.');
      /*setState(() {
        _isShowError = true;
        _errorMessage = 'Please provide the OTP.';
      });*/
    } else if (otp.length != 4) {
      otpErrorInfoData.updateOtpErrorInfoData(true, 'Please provide the valid OTP.');
      /*setState(() {
        _isShowError = true;
        _errorMessage = 'Please provide valid OTP.';
      });*/
    } else {
      _bloc.initNetworkStreamController();
      Utils.showApiLoaderDialog(
        context,
        networkStream: _bloc.networkStream,
        tapToRetryFunction: () {
          _bloc.enterDummyDataToNetworkStream();
          _bloc.callOtpVerifyApi(widget.otpValidationArgumentModel.email, otp, widget.otpValidationArgumentModel.isFromSignUp, widget.otpValidationArgumentModel.password, widget.otpValidationArgumentModel.isTermConditionCheck, widget.otpValidationArgumentModel.isEmailMarkCheck);
        }
      );
      _bloc.callOtpVerifyApi(widget.otpValidationArgumentModel.email, otp, widget.otpValidationArgumentModel.isFromSignUp, widget.otpValidationArgumentModel.password, widget.otpValidationArgumentModel.isTermConditionCheck, widget.otpValidationArgumentModel.isEmailMarkCheck);
    }
  }

  void _listenToOtpVerifyStream() {
    _bloc.otpVerifyStream.listen((event) {
      if(event != null && event is ForgotPasswordModel) {
        if(event.status == 1) {
          //Move to next screen
          if(!widget.otpValidationArgumentModel.isFromSignUp) {
            Future.delayed(Duration(milliseconds: 350), () {
              Navigator.pushReplacementNamed(
                  context, Constant.changePasswordScreenRouter,
                  arguments: ChangePasswordArgumentModel(emailValue: widget.otpValidationArgumentModel.email, isFromSignUp: widget.otpValidationArgumentModel.isForgotPasswordFromSignUp));
            });
          } else {
            Navigator.popUntil(context, ModalRoute.withName(Constant.onBoardingScreenSignUpRouter));
            Navigator.pushReplacementNamed(context, Constant.prePartTwoOnBoardScreenRouter);
          }
        } else {
          var otpErrorInfoData = Provider.of<OTPErrorInfo>(context, listen: false);
          otpErrorInfoData.updateOtpErrorInfoData(true, event.messageText);

          /*setState(() {
            _isShowError = true;
            _errorMessage = event.messageText;
          });*/
        }
      }
    });
  }

  void _onResendButtonClicked() {
    var otpTimerInfo = Provider.of<OTPTimerInfo>(context, listen: false);
    otpTimerInfo.updateTime(0);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var otpTimerInfo = Provider.of<OTPTimerInfo>(context, listen: false);
      if(timer.tick == 30) {
        timer.cancel();
      }

      otpTimerInfo.updateTime(timer.tick);
    });

    FocusScope.of(context).requestFocus(FocusNode());

    _bloc.callResendOTPApi(widget.otpValidationArgumentModel.email);
  }
}

class OTPValidationArgumentModel {
  String email;
  String password;
  bool isTermConditionCheck;
  bool isEmailMarkCheck;
  bool isFromSignUp;
  bool isForgotPasswordFromSignUp;

  OTPValidationArgumentModel({
    this.email,
    this.password,
    this.isFromSignUp = false,
    this.isForgotPasswordFromSignUp = false,
    this.isEmailMarkCheck = false,
    this.isTermConditionCheck = false,
  });
}

class OTPTimerInfo with ChangeNotifier {
  int _time = 0;

  int getTime() => _time;

  updateTime(int time) {
    _time = time;
    notifyListeners();
  }
}

class OTPErrorInfo with ChangeNotifier {
  bool _isShowError = false;
  String _errorMessage = Constant.blankString;

  bool isShowError() => _isShowError;
  String getErrorMessage() => _errorMessage;

  updateOtpErrorInfoData(bool isShowError, String errorMessage) {
    _isShowError = isShowError;
    _errorMessage = errorMessage;

    notifyListeners();
  }
}
