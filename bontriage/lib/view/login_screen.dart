import 'package:flutter/material.dart';
import 'package:mobile/blocs/LoginScreenBloc.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;

  String emailValue;
  String passwordValue;
  TextEditingController emailTextEditingController;
  TextEditingController passwordTextEditingController;
  LoginScreenBloc _loginScreenBloc;
  bool _isShowAlert = false;

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
    _loginScreenBloc = LoginScreenBloc();
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
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            Container(
                              height: 35,
                              child: TextFormField(
                                obscureText: _isHidden,
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
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                Constant.password,
                                style: TextStyle(
                                    fontFamily: Constant.jostRegular,
                                    fontSize: 13,
                                    color: Constant.chatBubbleGreen),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: _isShowAlert,
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 10),
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
                                      Constant.loginAlertMessage,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Constant.pinkTriggerColor,
                                          fontFamily: Constant.jostRegular),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          clickedLoginButton();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                          decoration: BoxDecoration(
                            color: Constant.chatBubbleGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            Constant.login,
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, Constant.welcomeStartAssessmentScreenRouter);
                        },
                        child: Text(
                          Constant.register,
                          style: TextStyle(
                              color: Constant.chatBubbleGreen,
                              fontSize: 14,
                              fontFamily: Constant.jostMedium,
                              decoration: TextDecoration.underline),

                        ),
                      )
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
  void clickedLoginButton() {
    if (emailValue != null &&
        passwordValue != null &&
        emailValue != "" &&
        passwordValue != "" &&
        Utils.validateEmail(emailValue)) {
      _isShowAlert = false;
      Utils.showApiLoaderDialog(context,
          networkStream: _loginScreenBloc.loginDataStream,
          tapToRetryFunction: () {
        _loginScreenBloc.enterSomeDummyDataToStream();
        loginService();
      });
      loginService();
    } else {
      setState(() {
        _isShowAlert = true;
      });

      /// TO:Do Show Error message
    }
  }

  /// This method will be use for to get response of Login API. If response is successful then navigate the screen into Home Screen.
  /// or not then show alert to the user into the screen.
  void loginService() async {
    var response = await _loginScreenBloc.getLoginOfUser(emailValue, passwordValue);
    if (response is String) {
      if (response == Constant.success) {
        _isShowAlert = false;
        Navigator.pop(context);
        Utils.navigateToHomeScreen(context, false);
      } else if (response == Constant.userNotFound) {
        _loginScreenBloc.init();
        Navigator.pop(context);
        setState(() {
          _isShowAlert = true;
        });
      }
    }
  }

  Future<bool> _onBackPressed() async {
    return true;
  }
}
