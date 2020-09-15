import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class OnBoardingSignUpScreen extends StatefulWidget {
  @override
  _OnBoardingSignUpScreenState createState() => _OnBoardingSignUpScreenState();
}

class _OnBoardingSignUpScreenState extends State<OnBoardingSignUpScreen> {
  bool _isHidden = true;

  var isTermConditionCheck = false;
  var isEmailMarkCheck = false;

  //Method to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constant.backgroundColor,
      body: Container(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 75, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  Constant.signUp,
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 20,
                      fontFamily: Constant.jostMedium),
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
                      fontFamily: Constant.jostMedium),
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
                          style: TextStyle(
                              fontSize: 15, fontFamily: Constant.jostMedium),
                          cursorColor: Constant.bubbleChatTextView,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: Constant.jostMedium),
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
                              fontWeight: FontWeight.bold,
                              fontFamily: Constant.jostRegular,
                              fontSize: 13,
                              color: Constant.chatBubbleGreen),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Theme(
                      data:ThemeData(unselectedWidgetColor: Constant.editTextBoarderColor),
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
                    Text(
                      Constant.termsAndCondition,
                      style: TextStyle(
                          height: 1.3,
                          fontFamily: Constant.jostRegular,
                          fontSize: 12,
                          color: Constant.chatBubbleGreen),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Theme(
                      data:ThemeData(unselectedWidgetColor: Constant.editTextBoarderColor),
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
                    Navigator.pushReplacementNamed(
                        context, Constant.prePartTwoOnBoardScreenRouter);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Constant.chatBubbleGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      Constant.signUp,
                      style: TextStyle(
                          fontFamily: Constant.jostMedium,
                          color: Constant.bubbleChatTextView,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  Constant.cancel,
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 16,
                      fontFamily: Constant.jostRegular,
                      decoration: TextDecoration.underline),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
