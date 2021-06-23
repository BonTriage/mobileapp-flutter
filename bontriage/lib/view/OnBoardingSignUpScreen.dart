import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/SignUpScreenBloc.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/OtpValidationScreen.dart';

class OnBoardingSignUpScreen extends StatefulWidget {
  @override
  _OnBoardingSignUpScreenState createState() => _OnBoardingSignUpScreenState();
}

class _OnBoardingSignUpScreenState extends State<OnBoardingSignUpScreen> {
  bool _isHidden = true;
  bool _isTermConditionCheck = false;
  bool _isEmailMarkCheck = false;
  String _emailValue;
  String _passwordValue;
  bool _isShowAlert = false;
  TextEditingController _emailTextEditingController;
  TextEditingController _passwordTextEditingController;
  SignUpScreenBloc _signUpScreenBloc;
  String _errorMsg;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  //Method to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _signUpScreenBloc = SignUpScreenBloc();
    Utils.saveUserProgress(0, Constant.signUpEventStep);
    _errorMsg = Constant.signUpAlertMessage;

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    });
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _signUpScreenBloc.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constant.backgroundColor,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Container(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 80),
                        child: Center(
                          child: Text(
                            Constant.signUp,
                            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                            style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 24,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        Constant.secureMigraineMentorAccount,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Constant.chatBubbleGreen,
                            fontSize: 15,
                            height: 1.3,
                            fontFamily: Constant.jostRegular),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 35,
                              child: TextFormField(
                                focusNode: _emailFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (String value) {
                                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                                },
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailTextEditingController,
                                onChanged: (String value) {
                                  _emailValue = _emailTextEditingController.text.trim();
                                },
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: Constant.jostMedium),
                                cursorColor: Constant.bubbleChatTextView,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontFamily: Constant.jostRegular),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                Constant.email,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 13,
                                    color: Constant.chatBubbleGreen),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 35,
                              child: TextFormField(
                                focusNode: _passwordFocusNode,
                                obscureText: _isHidden,
                                onFieldSubmitted: (String value) {
                                  _passwordValue =
                                      _passwordTextEditingController.text;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: _passwordTextEditingController,
                                onChanged: (String value) {
                                  _passwordValue =
                                      _passwordTextEditingController.text;
                                },
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: Constant.jostMedium),
                                cursorColor: Constant.bubbleChatTextView,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Constant.locationServiceGreen,
                                  suffixIcon: IconButton(
                                    onPressed: _togglePasswordVisibility,
                                    icon: Image.asset(_isHidden
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                Constant.password,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 13,
                                    color: Constant.chatBubbleGreen),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _isShowAlert,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 10),
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
                                width: 10,
                              ),
                              Text(
                                _errorMsg,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Constant.pinkTriggerColor,
                                    fontFamily: Constant.jostRegular),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    Constant.editTextBoarderColor),
                            child: Checkbox(
                              value: _isTermConditionCheck,
                              checkColor: Constant.bubbleChatTextView,
                              activeColor: Constant.chatBubbleGreen,
                              focusColor: Constant.chatBubbleGreen,
                              autofocus: true,
                              onChanged: (bool value) {
                                setState(() {
                                  _isTermConditionCheck = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  "I agree to the ",
                                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                  style: TextStyle(
                                      height: 1.3,
                                      fontFamily: Constant.jostRegular,
                                      fontSize: 12,
                                      color: Constant.chatBubbleGreen),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, Constant.webViewScreenRouter, arguments: Constant.termsAndConditionUrl);
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Text(
                                    "Terms & Condition",
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                    style: TextStyle(
                                        height: 1.3,
                                        fontFamily: Constant.jostRegular,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        color: Constant.chatBubbleGreen),
                                  ),
                                ),
                                Text(
                                  " and ",
                                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                  style: TextStyle(
                                      height: 1.3,
                                      fontFamily: Constant.jostRegular,
                                      fontSize: 12,
                                      color: Constant.chatBubbleGreen),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, Constant.webViewScreenRouter, arguments: Constant.privacyPolicyUrl);
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Text(
                                    "Privacy Policy",
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                    style: TextStyle(
                                        height: 1.3,
                                        fontFamily: Constant.jostRegular,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        color: Constant.chatBubbleGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    Constant.editTextBoarderColor),
                            child: Checkbox(
                              value: _isEmailMarkCheck,
                              checkColor: Constant.bubbleChatTextView,
                              activeColor: Constant.chatBubbleGreen,
                              focusColor: Constant.chatBubbleGreen,
                              onChanged: (bool value) {
                                setState(() {
                                  _isEmailMarkCheck = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Constant.emailFromMigraineMentor,
                              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                              style: TextStyle(
                                  height: 1.3,
                                  fontFamily: Constant.jostRegular,
                                  fontSize: 12,
                                  color: Constant.chatBubbleGreen),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          _signUpButtonClicked();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          decoration: BoxDecoration(
                            color: Constant.chatBubbleGreen,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            Constant.signUp,
                            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                            style: TextStyle(
                                fontFamily: Constant.jostMedium,
                                color: Constant.bubbleChatTextView,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              Constant.or,
                              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                              style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostRegular,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Constant.loginScreenRouter, arguments: true);
                              },
                              child: Text(
                                Constant.signIn,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                style: TextStyle(
                                    color: Constant.chatBubbleGreen,
                                    fontFamily: Constant.jostBold,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Utils.navigateToExitScreen(context);
                          },
                          child: Text(
                            Constant.cancel,
                            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                            style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostRegular,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// This method will be use for to check validation of Email & Password. So if all validation is verified then we will move to
  /// this screen to next screen. If not then show alert to the user.
  void _signUpButtonClicked() {
    _emailValue = _emailTextEditingController.text.trim().replaceAll(' ', Constant.blankString);
    _passwordValue = _passwordTextEditingController.text.trim();
    if (_emailValue != null &&
        _passwordValue != null &&
        Utils.validateEmail(_emailValue) &&
        _passwordValue.length >= 8 &&
        Utils.validatePassword(_passwordValue) &&
        _isTermConditionCheck) {
      _isShowAlert = false;
      checkUserAlreadySignUp();
    } else if (!Utils.validateEmail(_emailValue)) {
      setState(() {
        _errorMsg = Constant.signUpEmilFieldAlertMessage;
        _isShowAlert = true;
      });
    } else if (_passwordValue == null || _passwordValue.length < 8 || !Utils.validatePassword(_passwordValue)) {
      setState(() {
        _errorMsg = Constant.signUpAlertMessage;
        _isShowAlert = true;
      });
    } else {
      setState(() {
        _errorMsg = Constant.signUpCheckboxAlertMessage;
        _isShowAlert = true;
      });
    }
  }

  /// In this method we will check if user is already registered into the application. If user already registered then we will save User basic
  /// info data in local database for further use.If not then user can SignUp from the application.
  void checkUserAlreadySignUp() {
    _signUpScreenBloc.inItNetworkStream();
    Utils.showApiLoaderDialog(context,
        networkStream: _signUpScreenBloc.checkUserAlreadySignUpStream,
        tapToRetryFunction: () {
      _signUpScreenBloc.enterSomeDummyDataToStreamController();
      _callCheckUserAlreadySignUpApi();
    });
    _callCheckUserAlreadySignUpApi();
  }

  ///This method is used to call the api of check if user already signed up or not
  void _callCheckUserAlreadySignUpApi() async {
    var signUpResponse =
        await _signUpScreenBloc.checkUserAlreadyExistsOrNot(_emailValue);
    if (signUpResponse != null) {
      Navigator.pop(context);
      if (jsonDecode(signUpResponse)[Constant.messageTextKey] != null) {
        String messageValue =
            jsonDecode(signUpResponse)[Constant.messageTextKey];
        if (messageValue != null) {
          if (messageValue == Constant.userNotFound) {
            /*_getAnswerDataFromDatabase();*/
            _navigateToOtpVerifyScreen();
          }
        }
      } else {
        _errorMsg = 'Email Already Exists!';
        setState(() {
          _isShowAlert = true;
        });
      }
    }
  }

  /// This method will be use for to get User Profile data from Local database, If user didn't SignUp into the application.After We will
  /// get user Profile data from the local database then we implement SignUp Api to register user into the application.
  void _getAnswerDataFromDatabase() {
    Utils.showApiLoaderDialog(context,
        networkStream: _signUpScreenBloc.signUpOfNewUserStream,
        tapToRetryFunction: () {
      _signUpScreenBloc.enterSomeDummyDataToStreamController();
      _callSignUpOfNewUserApi();
    });
    _callSignUpOfNewUserApi();
  }

  ///This method is used to call sign up of new user api
  void _callSignUpOfNewUserApi() async {
    var selectedAnswerListData = await SignUpOnBoardProviders.db
        .getAllSelectedAnswers(Constant.zeroEventStep);
    var response = await _signUpScreenBloc.signUpOfNewUser(
        selectedAnswerListData, _emailValue, _passwordValue, _isTermConditionCheck, _isEmailMarkCheck);
    if (response is String) {
      if (response == Constant.success) {
        Navigator.pop(context);
        print(selectedAnswerListData);
        Navigator.pushReplacementNamed(
            context, Constant.prePartTwoOnBoardScreenRouter);
      }
    }
  }

  void _navigateToOtpVerifyScreen() {
    Navigator.pushNamed(context, Constant.otpValidationScreenRouter, arguments: OTPValidationArgumentModel(
      email: _emailValue,
      password: _passwordValue,
      isTermConditionCheck: _isTermConditionCheck,
      isEmailMarkCheck: _isEmailMarkCheck,
      isFromSignUp: true,
    ));
  }
}
