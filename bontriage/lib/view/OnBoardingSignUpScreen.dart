import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/SignUpScreenBloc.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class OnBoardingSignUpScreen extends StatefulWidget {
  @override
  _OnBoardingSignUpScreenState createState() => _OnBoardingSignUpScreenState();
}

class _OnBoardingSignUpScreenState extends State<OnBoardingSignUpScreen> {
  bool _isHidden = true;
  var isTermConditionCheck = false;
  var isEmailMarkCheck = false;
  String emailValue;
  String passwordValue;
  bool _isShowAlert = false;
  TextEditingController emailTextEditingController;
  TextEditingController passwordTextEditingController;
  SignUpScreenBloc signUpScreenBloc;
  UserProfileInfoModel userProfileInfoModel;
  String _errorMsg;

  //Method to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    signUpScreenBloc = SignUpScreenBloc();
    userProfileInfoModel = UserProfileInfoModel();
    Utils.saveUserProgress(0, Constant.signUpEventStep);
    _errorMsg = Constant.signUpAlertMessage;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
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
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 80),
                        child: Text(
                          Constant.signUp,
                          style: TextStyle(
                              color: Constant.chatBubbleGreen,
                              fontSize: 24,
                              fontFamily: Constant.jostMedium),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        Constant.secureMigraineMentorAccount,
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
                                onEditingComplete: () {
                                  emailValue = emailTextEditingController.text;
                                },
                                onFieldSubmitted: (String value) {
                                  emailValue = emailTextEditingController.text;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: emailTextEditingController,
                                onChanged: (String value) {
                                  emailValue = emailTextEditingController.text;
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
                                obscureText: _isHidden,
                                onEditingComplete: () {
                                  passwordValue =
                                      passwordTextEditingController.text;
                                },
                                onFieldSubmitted: (String value) {
                                  passwordValue =
                                      passwordTextEditingController.text;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: passwordTextEditingController,
                                onChanged: (String value) {
                                  passwordValue =
                                      passwordTextEditingController.text;
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
                          child: Row(
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
                              value: isTermConditionCheck,
                              checkColor: Constant.bubbleChatTextView,
                              activeColor: Constant.chatBubbleGreen,
                              focusColor: Constant.chatBubbleGreen,
                              autofocus: true,
                              onChanged: (bool value) {
                                setState(() {
                                  isTermConditionCheck = value;
                                });
                              },
                            ),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 12,
                                    color: Constant.chatBubbleGreen),
                              ),
                              TextSpan(
                                text: "Terms & Condition",
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    color: Constant.chatBubbleGreen),
                              ),
                              TextSpan(
                                text: " and ",
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 12,
                                    color: Constant.chatBubbleGreen),
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    color: Constant.chatBubbleGreen),
                              ),
                            ]),
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
                              value: isEmailMarkCheck,
                              checkColor: Constant.bubbleChatTextView,
                              activeColor: Constant.chatBubbleGreen,
                              focusColor: Constant.chatBubbleGreen,
                              onChanged: (bool value) {
                                setState(() {
                                  isEmailMarkCheck = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            Constant.emailFromMigraineMentor,
                            style: TextStyle(
                                height: 1.3,
                                fontFamily: Constant.jostRegular,
                                fontSize: 12,
                                color: Constant.chatBubbleGreen),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () {
                          signUpButtonClicked();
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
                                Navigator.pushReplacementNamed(
                                    context, Constant.loginScreenRouter);
                              },
                              child: Text(
                                Constant.signIn,
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
                      GestureDetector(
                        onTap: () {
                          Utils.navigateToExitScreen(context);
                        },
                        child: Text(
                          Constant.cancel,
                          style: TextStyle(
                              color: Constant.chatBubbleGreen,
                              fontSize: 16,
                              fontFamily: Constant.jostRegular,
                              decoration: TextDecoration.underline),
                        ),
                      )
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
  void signUpButtonClicked() {
    if (emailValue != null &&
        passwordValue != null &&
        Utils.validateEmail(emailValue) &&
        passwordValue.length >= 8 &&
        Utils.validatePassword(passwordValue) &&
        isTermConditionCheck) {
      _isShowAlert = false;
      checkUserAlreadySignUp();
    } else if (!Utils.validateEmail(emailValue)) {
      setState(() {
        _errorMsg = Constant.signUpEmilFieldAlertMessage;
        _isShowAlert = true;
      });
    } else if (passwordValue.length < 8 &&
        !Utils.validatePassword(passwordValue)) {
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
    Utils.showApiLoaderDialog(context,
        networkStream: signUpScreenBloc.checkUserAlreadySignUpStream,
        tapToRetryFunction: () {
      signUpScreenBloc.enterSomeDummyDataToStreamController();
      _callCheckUserAlreadySignUpApi();
    });
    _callCheckUserAlreadySignUpApi();
  }

  ///This method is used to call the api of check if user already signed up or not
  void _callCheckUserAlreadySignUpApi() async {
    var signUpResponse =
        await signUpScreenBloc.checkUserAlreadyExistsOrNot(emailValue);
    if (signUpResponse != null) {
      Navigator.pop(context);
      if (jsonDecode(signUpResponse)[Constant.messageTextKey] != null) {
        String messageValue =
            jsonDecode(signUpResponse)[Constant.messageTextKey];
        if (messageValue != null) {
          if (messageValue == Constant.userNotFound) {
            getAnswerDataFromDatabase();
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
  void getAnswerDataFromDatabase() {
    Utils.showApiLoaderDialog(context,
        networkStream: signUpScreenBloc.signUpOfNewUserStream,
        tapToRetryFunction: () {
      signUpScreenBloc.enterSomeDummyDataToStreamController();
      _callSignUpOfNewUserApi();
    });
    _callSignUpOfNewUserApi();
  }

  ///This method is used to call sign up of new user api
  void _callSignUpOfNewUserApi() async {
    var selectedAnswerListData = await SignUpOnBoardProviders.db
        .getAllSelectedAnswers(Constant.zeroEventStep);
    var response = await signUpScreenBloc.signUpOfNewUser(
        selectedAnswerListData, emailValue, passwordValue);
    if (response is String) {
      if (response == Constant.success) {
        Navigator.pop(context);
        print(selectedAnswerListData);
        Navigator.pushReplacementNamed(
            context, Constant.prePartTwoOnBoardScreenRouter);
      }
    }
  }
}
