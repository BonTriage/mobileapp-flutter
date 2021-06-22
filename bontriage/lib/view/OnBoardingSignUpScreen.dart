import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/SignUpScreenBloc.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CustomTextFormField.dart';
import 'package:mobile/view/OtpValidationScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'CustomTextWidget.dart';

class OnBoardingSignUpScreen extends StatefulWidget {
  @override
  _OnBoardingSignUpScreenState createState() => _OnBoardingSignUpScreenState();
}

class _OnBoardingSignUpScreenState extends State<OnBoardingSignUpScreen> {
  String _emailValue;
  String _passwordValue;
  TextEditingController _emailTextEditingController;
  TextEditingController _passwordTextEditingController;
  SignUpScreenBloc _signUpScreenBloc;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  //Method to toggle password visibility
  void _togglePasswordVisibility() {
    var passwordVisibilityInfo = Provider.of<PasswordVisibilityInfo>(context, listen: false);
    passwordVisibilityInfo.updateIsHidden(!passwordVisibilityInfo.isHidden());
  }

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _signUpScreenBloc = SignUpScreenBloc();
    Utils.saveUserProgress(0, Constant.signUpEventStep);

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
    debugPrint('in build func of sign up screen');
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
                          child: CustomTextWidget(
                            text: Constant.signUp,
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
                      CustomTextWidget(
                        text: Constant.secureMigraineMentorAccount,
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
                              child: CustomTextFormField(
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
                              child: CustomTextWidget(
                                text: Constant.email,
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
                              child: Consumer<PasswordVisibilityInfo>(
                                builder: (context, data, child) {
                                  return CustomTextFormField(
                                    focusNode: _passwordFocusNode,
                                    obscureText: data.isHidden(),
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
                                              width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                          borderSide: BorderSide(
                                              color: Constant.editTextBoarderColor,
                                              width: 1)),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: CustomTextWidget(
                                text: Constant.password,
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
                      Consumer<SignUpErrorInfo>(
                        builder: (context, data, child) {
                          return Visibility(
                            visible: data.isShowAlert(),
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
                                  CustomTextWidget(
                                    text: data.getErrorMessage(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Constant.pinkTriggerColor,
                                        fontFamily: Constant.jostRegular),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
                            child: Consumer<TermConditionInfo>(
                              builder: (context, data, child) {
                                return Checkbox(
                                  value: data.isTermConditionCheck(),
                                  checkColor: Constant.bubbleChatTextView,
                                  activeColor: Constant.chatBubbleGreen,
                                  focusColor: Constant.chatBubbleGreen,
                                  autofocus: true,
                                  onChanged: (bool value) {
                                    var termConditionCheck = Provider.of<TermConditionInfo>(context, listen: false);
                                    termConditionCheck.updateIsTermConditionCheck(value);
                                  },
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                CustomTextWidget(
                                  text: "I agree to the ",
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
                                  child: CustomTextWidget(
                                    text: "Terms & Condition",
                                    style: TextStyle(
                                        height: 1.3,
                                        fontFamily: Constant.jostRegular,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        color: Constant.chatBubbleGreen),
                                  ),
                                ),
                                CustomTextWidget(
                                  text: " and ",
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
                                  child: CustomTextWidget(
                                    text: "Privacy Policy",
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
                            child: Consumer<EmailUpdatesInfo>(
                              builder: (context, data, child) {
                                return Checkbox(
                                  value: data.isEmailMarkCheck(),
                                  checkColor: Constant.bubbleChatTextView,
                                  activeColor: Constant.chatBubbleGreen,
                                  focusColor: Constant.chatBubbleGreen,
                                  onChanged: (bool value) {
                                    var emailUpdatesInfo = Provider.of<EmailUpdatesInfo>(context, listen: false);
                                    emailUpdatesInfo.updateIsEmailMarkCheck(value);
                                  },
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomTextWidget(
                              text: Constant.emailFromMigraineMentor,
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
                          child: CustomTextWidget(
                            text: Constant.signUp,
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
                            child: CustomTextWidget(
                              text: Constant.or,
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
                              child: CustomTextWidget(
                                text: Constant.signIn,
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
                          child: CustomTextWidget(
                            text: Constant.cancel,
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
    FocusScope.of(context).requestFocus(FocusNode());
    _emailValue = _emailTextEditingController.text.trim().replaceAll(' ', Constant.blankString);
    _passwordValue = _passwordTextEditingController.text.trim();

    var signUpErrorInfo = Provider.of<SignUpErrorInfo>(context, listen: false);

    var termConditionInfo = Provider.of<TermConditionInfo>(context, listen: false);

    if (_emailValue != null &&
        _passwordValue != null &&
        Utils.validateEmail(_emailValue) &&
        _passwordValue.length >= 8 &&
        Utils.validatePassword(_passwordValue) &&
        termConditionInfo.isTermConditionCheck()) {
      signUpErrorInfo.updateSignUpErrorInfo(false, Constant.blankString);
      checkUserAlreadySignUp();
    } else if (!Utils.validateEmail(_emailValue)) {
      signUpErrorInfo.updateSignUpErrorInfo(true, Constant.signUpEmilFieldAlertMessage);
    } else if (_passwordValue == null || _passwordValue.length < 8 || !Utils.validatePassword(_passwordValue)) {
      signUpErrorInfo.updateSignUpErrorInfo(true, Constant.signUpAlertMessage);
    } else {
      signUpErrorInfo.updateSignUpErrorInfo(true, Constant.signUpCheckboxAlertMessage);
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
    var signUpResponse = await _signUpScreenBloc.checkUserAlreadyExistsOrNot(_emailValue);
    if (signUpResponse != null) {
      Navigator.pop(context);
      if (jsonDecode(signUpResponse)[Constant.messageTextKey] != null) {
        String messageValue =
            jsonDecode(signUpResponse)[Constant.messageTextKey];
        if (messageValue != null) {
          if (messageValue == Constant.userNotFound) {
            _navigateToOtpVerifyScreen();
          }
        }
      } else {
        var signUpErrorInfo = Provider.of<SignUpErrorInfo>(context, listen: false);
        signUpErrorInfo.updateSignUpErrorInfo(true, 'Email Already Exists!');
      }
    }
  }

  void _navigateToOtpVerifyScreen() {
    var termConditionInfo = Provider.of<TermConditionInfo>(context, listen: false);
    var emailUpdatedInfo = Provider.of<EmailUpdatesInfo>(context, listen: false);

    Navigator.pushNamed(
        context,
        Constant.otpValidationScreenRouter,
        arguments: OTPValidationArgumentModel(
      email: _emailValue,
      password: _passwordValue,
      isTermConditionCheck: termConditionInfo.isTermConditionCheck(),
      isEmailMarkCheck: emailUpdatedInfo.isEmailMarkCheck(),
      isFromSignUp: true,)
    );
  }
}

class SignUpErrorInfo with ChangeNotifier {
  bool _isShowAlert = false;
  String _errorMessage = Constant.blankString;

  bool isShowAlert ()=> _isShowAlert;
  String getErrorMessage ()=> _errorMessage;

  updateSignUpErrorInfo(bool isShowAlert, String errorMessage) {
    _isShowAlert = isShowAlert;
    _errorMessage = errorMessage;

    notifyListeners();
  }
}

class PasswordVisibilityInfo with ChangeNotifier {
  bool _isHidden = true;
  bool isHidden() => _isHidden;

  updateIsHidden(bool isHidden) {
    _isHidden = isHidden;
    notifyListeners();
  }
}

class TermConditionInfo with ChangeNotifier {
  bool _isTermConditionCheck = false;
  bool isTermConditionCheck() => _isTermConditionCheck;

  updateIsTermConditionCheck(bool isTermConditionCheck) {
    _isTermConditionCheck = isTermConditionCheck;
    notifyListeners();
  }
}

class EmailUpdatesInfo with ChangeNotifier {
  bool _isEmailMarkCheck = false;
  bool isEmailMarkCheck() => _isEmailMarkCheck;

  updateIsEmailMarkCheck(bool isEmailMarkCheck) {
    _isEmailMarkCheck = isEmailMarkCheck;
    notifyListeners();
  }
}
