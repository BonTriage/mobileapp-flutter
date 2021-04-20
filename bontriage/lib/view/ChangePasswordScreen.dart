import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/ChangePasswordScreenBloc.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  final ChangePasswordArgumentModel changePasswordArgumentModel;

  const ChangePasswordScreen({Key key, this.changePasswordArgumentModel}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isHidden = true;
  bool _isConfirmPasswordHidden = true;

  String passwordValue;
  TextEditingController passwordTextEditingController;
  TextEditingController confirmPasswordTextEditingController;

  String confirmPasswordValue;
  ChangePasswordBloc _changePasswordBloc;

  bool _isShowAlert = false;

  String alertMessage = '';

  FocusNode passwordFocusNode;
  FocusNode confirmPasswordFocusNode;

  //Method to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  //Method to toggle password visibility
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = ChangePasswordBloc();
    confirmPasswordTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();

    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(passwordFocusNode);
    });
  }

  @override
  void dispose() {
    confirmPasswordTextEditingController.dispose();
    passwordTextEditingController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constant.backgroundColor,
      body: MediaQuery(
        data: mediaQueryData.copyWith(
          textScaleFactor: mediaQueryData.textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.minTextScaleFactor),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Create New Password',
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 18,
                      fontFamily: Constant.jostRegular),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'New Password',
                  style: TextStyle(
                      fontFamily: Constant.jostRegular,
                      fontSize: 13,
                      color: Constant.chatBubbleGreen),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 35,
                  child: TextFormField(
                    obscureText: _isHidden,
                    focusNode: passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    controller: passwordTextEditingController,
                    onChanged: (String value) {
                      passwordValue = passwordTextEditingController.text;
                    },
                    onFieldSubmitted: (text) {
                      FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                    },
                    style: TextStyle(fontSize: 15, fontFamily: Constant.jostMedium),
                    cursorColor: Constant.bubbleChatTextView,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      hintStyle: TextStyle(fontSize: 15, color: Colors.black),
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
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                              color: Constant.editTextBoarderColor, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                              color: Constant.editTextBoarderColor, width: 1)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Confirm Password',
                  style: TextStyle(
                      fontFamily: Constant.jostRegular,
                      fontSize: 13,
                      color: Constant.chatBubbleGreen),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 35,
                  child: TextFormField(
                    obscureText: _isConfirmPasswordHidden,
                    focusNode: confirmPasswordFocusNode,
                    onFieldSubmitted: (String value) {
                      _clickedChangePasswordButton();
                    },
                    controller: confirmPasswordTextEditingController,
                    onChanged: (String value) {
                      confirmPasswordValue = confirmPasswordTextEditingController.text;
                    },
                    style: TextStyle(fontSize: 15, fontFamily: Constant.jostMedium),
                    cursorColor: Constant.bubbleChatTextView,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                      filled: true,
                      fillColor: Constant.locationServiceGreen,
                      suffixIcon: IconButton(
                        onPressed: _toggleConfirmPasswordVisibility,
                        icon: Image.asset(_isConfirmPasswordHidden
                            ? Constant.hidePassword
                            : Constant.showPassword),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minHeight: 30,
                        maxHeight: 35,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                              color: Constant.editTextBoarderColor, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                              color: Constant.editTextBoarderColor, width: 1)),
                    ),
                  ),
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
                        alertMessage,
                        style: TextStyle(
                            fontSize: 13,
                            color: Constant.pinkTriggerColor,
                            fontFamily: Constant.jostRegular),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: BouncingWidget(
                  onPressed: () {
                    _clickedChangePasswordButton();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffafd794),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Change Password',
                        textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(Constant.minTextScaleFactor,
                                Constant.maxTextScaleFactor),
                        style: TextStyle(
                            color: Constant.bubbleChatTextView,
                            fontSize: 15,
                            fontFamily: Constant.jostMedium),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clickedChangePasswordButton() {
    FocusScope.of(context).requestFocus(FocusNode());
    passwordValue = passwordTextEditingController.text.trim();
    confirmPasswordValue = confirmPasswordTextEditingController.text.trim();
    if (passwordValue == null ||
        passwordValue.length < 8 ||
        !Utils.validatePassword(passwordValue)) {
      setState(() {
        alertMessage = Constant.signUpAlertMessage;
        _isShowAlert = true;
      });
    } else if (confirmPasswordValue == null ||
        confirmPasswordValue.length < 8 ||
        !Utils.validatePassword(confirmPasswordValue)) {
      setState(() {
        alertMessage = Constant.signUpAlertMessage;
        _isShowAlert = true;
      });
    } else if (passwordValue != confirmPasswordValue) {
      setState(() {
        alertMessage = Constant.passwordNotMatchMessage;
        _isShowAlert = true;
      });

    } else {
      _isShowAlert = false;
      Utils.showApiLoaderDialog(context,
          networkStream: _changePasswordBloc.changePasswordDataStream,
          tapToRetryFunction: () {
        _changePasswordBloc.enterSomeDummyDataToStreamController();
        changePasswordService();
      });
      changePasswordService();
    }
  }

  void changePasswordService() async {
    var responseData = await _changePasswordBloc.sendChangePasswordData(widget.changePasswordArgumentModel.emailValue, passwordValue);
    if (responseData is String) {
      if (responseData == Constant.success) {
        _isShowAlert = false;
        if(!widget.changePasswordArgumentModel.isFromSignUp)
          Navigator.popUntil(context, ModalRoute.withName(Constant.welcomeStartAssessmentScreenRouter));
        else
          Navigator.popUntil(context, ModalRoute.withName(Constant.onBoardingScreenSignUpRouter));

        Utils.navigateToHomeScreen(context, false);
      }
    }
  }
}

class ChangePasswordArgumentModel {
  String emailValue;
  bool isFromSignUp;

  ChangePasswordArgumentModel({this.emailValue, this.isFromSignUp = false});
}
