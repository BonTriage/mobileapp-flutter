import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/constant.dart';

class WelcomeStartAssessmentScreen extends StatefulWidget {
  @override
  _WelcomeStartAssessmentScreenState createState() =>
      _WelcomeStartAssessmentScreenState();
}

class _WelcomeStartAssessmentScreenState
    extends State<WelcomeStartAssessmentScreen> {
  bool _isUserAlreadyLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUserAlreadyLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: mediaQueryData.textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
          ),
          child: Container(
            decoration: Constant.backgroundBoxDecoration,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: mediaQueryData.size.height
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: Constant.screenHorizontalPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(Constant.compassGreen),
                              width: 78,
                              height: 78,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${Constant.migraineMentor}\u2122',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontSize: 24,
                                fontFamily: Constant.jostMedium,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 100),
                        Text(
                          Constant.conquerYourHeadaches,
                          style: TextStyle(
                            color: Constant.chatBubbleGreen,
                            fontSize: 20,
                            fontFamily: Constant.jostMedium,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          Constant.personalizedUnderstanding,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constant.locationServiceGreen,
                            height: 1.3,
                            fontSize: 15,
                            fontFamily: Constant.jostRegular,
                          ),
                        ),
                        SizedBox(height: 100),
                        BouncingWidget(
                          onPressed: () {
                            Utils.navigateToUserOnProfileBoard(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Constant.chatBubbleGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              Constant.startYourAssessment,
                              style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: _isUserAlreadyLoggedIn,
                          child: GestureDetector(
                            onTap: () {
                              _moveToHomeScreen();
                            },
                            child: Text(
                              Constant.cancelAssessment,
                              style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostRegular,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 1),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !_isUserAlreadyLoggedIn,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Constant.or,
                                style: TextStyle(
                                  wordSpacing: 1,
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostRegular,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Constant.loginScreenRouter, arguments: false);
                                },
                                child: Text(
                                  Constant.signIn,
                                  style: TextStyle(
                                      color: Constant.chatBubbleGreen,
                                      fontFamily: Constant.jostBold,
                                      wordSpacing: 1,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 1),
                                ),
                              ),
                              Text(
                                Constant.toAn,
                                style: TextStyle(
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostRegular,
                                  fontSize: 15,
                                  wordSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Visibility(
                          visible: !_isUserAlreadyLoggedIn,
                          child: Text(
                            Constant.existingAccount,
                            style: TextStyle(
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostRegular,
                                fontSize: 15,
                                wordSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async{
    return true;
  }

  void _checkUserAlreadyLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      _isUserAlreadyLoggedIn = sharedPreferences.getBool(Constant.userAlreadyLoggedIn) ?? false;
    });
  }

  void _moveToHomeScreen() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isProfileInComplete = sharedPreferences.getBool(Constant.isProfileInCompleteStatus) ?? false;
    Utils.navigateToHomeScreen(context, isProfileInComplete);
  }
}
