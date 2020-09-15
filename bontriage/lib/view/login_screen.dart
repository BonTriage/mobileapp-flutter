import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;

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
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage(Constant.brain),
                      width: 56,
                      height: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      Constant.migraineMentor,
                      style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontSize: 20,
                          fontFamily: Constant.futuraMaxiLight,
                          fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 15),
                          cursorColor: Constant.bubbleChatTextView,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            filled: true,
                            fillColor: Constant.locationServiceGreen,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          Constant.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Constant.chatBubbleGreen
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 35,
                        child: TextFormField(
                          obscureText: _isHidden,
                          style: TextStyle(fontSize: 15),
                          cursorColor: Constant.bubbleChatTextView,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            hintStyle:
                            TextStyle(fontSize: 15, color: Colors.black),
                            filled: true,
                            fillColor: Constant.locationServiceGreen,
                            suffixIcon: IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: Image.asset(_isHidden ? Constant.hidePassword : Constant.showPassword),
                            ),
                            suffixIconConstraints: BoxConstraints(
                              minHeight: 30,
                              maxHeight: 35,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 12,
                              color: Constant.chatBubbleGreen
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Constant.chatBubbleGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      Constant.login,
                      style: TextStyle(color: Constant.bubbleChatTextView, fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  Constant.register,
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: Constant.futuraMaxiLight,
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
