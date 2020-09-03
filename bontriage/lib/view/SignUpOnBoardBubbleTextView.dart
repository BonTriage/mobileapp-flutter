import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/PhotoHero.dart';
import 'package:mobile/util/constant.dart';

import 'ChatBubbleLeftPointed.dart';

class SignUpOnBoardBubbleTextView extends StatefulWidget {
  @override
  _StateSignUpOnBoardBubbleTextView createState() =>
      _StateSignUpOnBoardBubbleTextView();
}

class _StateSignUpOnBoardBubbleTextView
    extends State<SignUpOnBoardBubbleTextView> {
  bool isFirstTextVisible = false;
  bool isVolumeOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
// The blue background emphasizes that it's a new route.
        decoration: Constant.backgroundBoxDecoration,
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage(Constant.closeIcon),
                    width: 26,
                    height: 26,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhotoHero(
                    photo: 'images/user_avatar.png',
                    width: 70.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                    image: AssetImage(
                        isVolumeOn ? Constant.volumeOn : Constant.volumeOff),
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ChatBubbleLeftPointed(
                painter: ChatBubblePainter(Constant.chatBubbleGreen),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                      '${isFirstTextVisible ? Constant.migraineMentorHelpTextView : Constant.welcomeMigraineMentorTextView}',
                      style: TextStyle(
                          height: 1.5,
                          fontSize: 14,
                          color: Constant.bubbleChatTextView,
                          fontWeight: FontWeight.bold,
                          fontFamily: "FuturaMaxiLight")),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  BouncingWidget(
                    duration: Duration(milliseconds: 100),
                    scaleFactor: 1.5,
                    onPressed: () {
                      setState(() {
                        if (isFirstTextVisible) {
                          {
                            Navigator.pushReplacementNamed(context,
                                Constant.signUpOnBoardStartAssessmentRouter);
                          }
                          isFirstTextVisible = false;
                        } else {
                          isFirstTextVisible = true;
                        }
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffafd794),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          Constant.next,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        /* child: PhotoHero(
              photo: 'images/user_avatar.png',
              width: 60.0,

            ),*/
      ),
    );
  }
}
