import 'package:flutter/material.dart';
import 'package:mobile/blocs/LoginScreenBloc.dart';
import 'package:mobile/models/ForgotPasswordModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OtpValidationScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final bool isFromSignUp;

  const LoginScreen({Key key, this.isFromSignUp = false}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  String emailValue;
  String passwordValue;
  TextEditingController emailTextEditingController;
  TextEditingController passwordTextEditingController;
  LoginScreenBloc _loginScreenBloc;
  AnimationController _sizeAnimationController;

  //Method to toggle password visibility
  void _togglePasswordVisibility() {
    var passwordHiddenInfo = Provider.of<PasswordHiddenInfo>(context, listen: false);
    passwordHiddenInfo.updateIsHidden(!passwordHiddenInfo.isHidden());
  }

  @override
  void initState() {
    super.initState();
    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    _loginScreenBloc = LoginScreenBloc();

    _sizeAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300), reverseDuration: Duration(milliseconds: 300));

    _sizeAnimationController.forward();

    _listenToForgotPasswordStream();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    _sizeAnimationController.dispose();
    _loginScreenBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: Constant.backgroundBoxDecoration,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image(
                        image: AssetImage(Constant.closeIcon),
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage(Constant.compassGreen),
                            width: 78,
                            height: 78,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            Constant.migraineMentor,
                            style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 24,
                                fontFamily: Constant.jostMedium),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        margin: EdgeInsets.only(top: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 35,
                              child: TextFormField(
                                onEditingComplete: () {
                                  emailValue = emailTextEditingController.text;
                                },
                                onFieldSubmitted: (String value) {
                                  emailValue = emailTextEditingController.text;
                                  FocusScope.of(context).requestFocus(FocusNode());
                                },
                                controller: emailTextEditingController,
                                onChanged: (String value) {
                                  emailValue = emailTextEditingController.text;
                                },
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontSize: 15, fontFamily: Constant.jostMedium),
                                cursorColor: Constant.bubbleChatTextView,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  hintStyle:
                                  TextStyle(fontSize: 15, color: Colors.black),
                                  filled: true,
                                  fillColor: Constant.locationServiceGreen,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                      borderSide: BorderSide(
                                          color: Constant.editTextBoarderColor,
                                          width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                      borderSide: BorderSide(
                                          color: Constant.editTextBoarderColor,
                                          width: 1)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                Constant.email,
                                style: TextStyle(
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 13,
                                    color: Constant.chatBubbleGreen),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizeTransition(
                              sizeFactor: _sizeAnimationController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 35,
                                    child: Consumer<PasswordHiddenInfo>(
                                      builder: (context, data, child) {
                                        return TextFormField(
                                          obscureText: data.isHidden(),
                                          onEditingComplete: () {
                                            passwordValue = passwordTextEditingController.text;
                                          },
                                          onFieldSubmitted: (String value) {
                                            passwordValue = passwordTextEditingController.text;
                                            FocusScope.of(context).requestFocus(FocusNode());
                                          },
                                          controller: passwordTextEditingController,
                                          onChanged: (String value) {
                                            passwordValue = passwordTextEditingController.text;
                                          },
                                          style: TextStyle(
                                              fontSize: 15, fontFamily: Constant.jostMedium),
                                          cursorColor: Constant.bubbleChatTextView,
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 20),
                                            hintStyle:
                                            TextStyle(fontSize: 15, color: Colors.black),
                                            filled: true,
                                            fillColor: Constant.locationServiceGreen,
                                            suffixIcon: IconButton(
                                              onPressed: _togglePasswordVisibility,
                                              icon: Image.asset(data.isHidden()
                                                  ? Constant.hidePassword
                                                  : Constant.showPassword),
                                            ),
                                            suffixIconConstraints: BoxConstraints(
                                              minHeight: 30,
                                              maxHeight: 35,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(30)),
                                              borderSide: BorderSide(
                                                  color: Constant.editTextBoarderColor,
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(30)),
                                              borderSide: BorderSide(
                                                  color: Constant.editTextBoarderColor,
                                                  width: 1),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      Constant.password,
                                      style: TextStyle(
                                          fontFamily: Constant.jostRegular,
                                          fontSize: 13,
                                          color: Constant.chatBubbleGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Consumer<LoginErrorInfo>(
                              builder: (context, data, child) {
                                return Visibility(
                                  visible: data.isShowAlert(),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20, right: 10, top: 10),
                                    child: Row(
                                      children: [
                                        Image(
                                          image: AssetImage(Constant.warningPink),
                                          width: 17,
                                          height: 17,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data.getErrorMessage(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Constant.pinkTriggerColor,
                                              fontFamily: Constant.jostRegular),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizeTransition(
                              sizeFactor: _sizeAnimationController,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _forgotPasswordClicked();
                                    },
                                    child: Text(
                                      Constant.forgotPassword,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: Constant.jostMedium,
                                          fontSize: 13,
                                          color: Constant.chatBubbleGreen),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<ForgotPasswordClickedInfo>(
                        builder: (context, data, child) {
                          return Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  if(!data.isForgotPasswordClicked())
                                    _clickedLoginButton();
                                  else
                                    _clickedNextButton();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                                  decoration: BoxDecoration(
                                    color: Constant.chatBubbleGreen,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    !data.isForgotPasswordClicked() ? Constant.login : Constant.next,
                                    style: TextStyle(
                                        color: Constant.bubbleChatTextView,
                                        fontSize: 14,
                                        fontFamily: Constant.jostMedium,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AnimatedCrossFade(
                                  crossFadeState: !data.isForgotPasswordClicked()
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  duration: Duration(milliseconds: 300),
                                  firstChild: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      Constant.register,
                                      style: TextStyle(
                                          color: Constant.chatBubbleGreen,
                                          fontSize: 14,
                                          fontFamily: Constant.jostMedium,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  secondChild: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(FocusNode());

                                      var forgotPasswordClickedInfoData = Provider.of<ForgotPasswordClickedInfo>(context, listen: false);
                                      forgotPasswordClickedInfoData.updateForgotPasswordClicked(false);

                                      var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
                                      loginErrorInfoData.updateLoginErrorInfo(false, Constant.blankString);

                                      emailTextEditingController.text = Constant.blankString;
                                      passwordTextEditingController.text = Constant.blankString;
                                      _sizeAnimationController.forward();
                                    },
                                    child: Text(
                                      "Switch to login",
                                      style: TextStyle(
                                          color: Constant.chatBubbleGreen,
                                          fontSize: 14,
                                          fontFamily: Constant.jostMedium,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                              ),
                            ],
                          );
                        },
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

  /// This method will be use for to Check Validation of Email and Password value. If condition is true then we will hit the API.
  /// or not then show alert to user into the screen.
  void _clickedLoginButton() {
    if (emailValue != null &&
        passwordValue != null &&
        emailValue != "" &&
        passwordValue != "" &&
        Utils.validateEmail(emailValue)) {
      var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
      loginErrorInfoData.updateLoginErrorInfo(false, Constant.blankString);

      Utils.showApiLoaderDialog(context,
          networkStream: _loginScreenBloc.loginDataStream,
          tapToRetryFunction: () {
            _loginScreenBloc.enterSomeDummyDataToStream();
            _loginService();
          });
      _loginService();
    } else {
      var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
      loginErrorInfoData.updateLoginErrorInfo(true, Constant.loginAlertMessage);
      /// TO:Do Show Error message
    }
  }

  /// This method will be use for to get response of Login API. If response is successful then navigate the screen into Home Screen.
  /// or not then show alert to the user into the screen.
  void _loginService() async {
    var response = await _loginScreenBloc.getLoginOfUser(emailValue, passwordValue);
    if (response is String) {
      if (response == Constant.success) {
        var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
        loginErrorInfoData.updateLoginErrorInfo(false, Constant.blankString);

        if(widget.isFromSignUp) {
          Navigator.popUntil(context, ModalRoute.withName(Constant.onBoardingScreenSignUpRouter));
        } else {
          Navigator.popUntil(context, ModalRoute.withName(Constant.welcomeStartAssessmentScreenRouter));
        }

        Utils.navigateToHomeScreen(context, false);
      } else if (response == Constant.userNotFound) {
        _loginScreenBloc.init();
        Navigator.pop(context);

        var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
        loginErrorInfoData.updateLoginErrorInfo(true, Constant.loginAlertMessage);
      }
    }
  }

  Future<bool> _onBackPressed() async {
    return true;
  }

  void _forgotPasswordClicked() async {
    FocusScope.of(context).requestFocus(FocusNode());

    var forgotPasswordClickedInfoData = Provider.of<ForgotPasswordClickedInfo>(context, listen: false);
    forgotPasswordClickedInfoData.updateForgotPasswordClicked(true);

    var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
    loginErrorInfoData.updateLoginErrorInfo(false, Constant.blankString);

    emailTextEditingController.text = Constant.blankString;
    passwordTextEditingController.text = Constant.blankString;
    _sizeAnimationController.reverse();
  }

  void _listenToForgotPasswordStream() {
    _loginScreenBloc.forgotPasswordStream.listen((event) {
      if(event != null && event is ForgotPasswordModel) {
        if(event.status == 1) {
          Future.delayed(Duration(milliseconds: 350), () {
            Navigator.pushNamed(
                context,
                Constant.otpValidationScreenRouter,
                arguments: OTPValidationArgumentModel(
                    email: emailTextEditingController.text.trim(),
                    isForgotPasswordFromSignUp: widget.isFromSignUp ?? false,)
            );
          });
        } else {
          var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
          loginErrorInfoData.updateLoginErrorInfo(true, event.messageText);
        }
      }
    });
  }

  void _clickedNextButton() {
    String email = emailTextEditingController.text.trim();

    if(email != null && email.isEmpty) {
      var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
      loginErrorInfoData.updateLoginErrorInfo(true, 'Please enter you Email.');
    } else if(!Utils.validateEmail(email)) {
      var loginErrorInfoData = Provider.of<LoginErrorInfo>(context, listen: false);
      loginErrorInfoData.updateLoginErrorInfo(true, 'Invalid Email Address.');
    } else {
      _loginScreenBloc.initNetworkStreamController();
      Utils.showApiLoaderDialog(
          context,
          networkStream: _loginScreenBloc.networkStream,
          tapToRetryFunction: () {
            _loginScreenBloc.enterDummyDataToNetworkStream();
            _loginScreenBloc.callForgotPasswordApi(email);
          }
      );
      _loginScreenBloc.callForgotPasswordApi(email);
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

class PasswordHiddenInfo with ChangeNotifier {
  bool _isHidden = false;

  bool isHidden() => _isHidden;

  updateIsHidden(bool isHidden) {
    _isHidden = isHidden;

    notifyListeners();
  }
}

class ForgotPasswordClickedInfo with ChangeNotifier {
  bool _isForgotPasswordClicked = false;

  bool isForgotPasswordClicked() => _isForgotPasswordClicked;

  updateForgotPasswordClicked(bool isForgotPasswordClicked) {
    _isForgotPasswordClicked = isForgotPasswordClicked;
    notifyListeners();
  }
}

class LoginErrorInfo with ChangeNotifier {
  bool _isShowAlert = false;
  String _errorMessage = Constant.blankString;

  bool isShowAlert() => _isShowAlert;
  String getErrorMessage() => _errorMessage;

  updateLoginErrorInfo(bool isShowAlert, String errorMessage) {
    _isShowAlert = isShowAlert;
    _errorMessage = errorMessage;

    notifyListeners();
  }
}