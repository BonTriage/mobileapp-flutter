import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/util/constant.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WelcomePage extends StatelessWidget {
  final String headerText;
  final String imagePath;
  final String subText;

   const WelcomePage({Key key, this.headerText, this.imagePath, this.subText})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 68
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                headerText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constant.chatBubbleGreen,
                  fontSize: 24,
                  fontFamily: Constant.jostRegular,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(
                    left: imagePath == Constant.notifsGreenShadow ? 15 : 0),
                child: Image(
                  width: 170,
                  height: 170,
                  alignment: Alignment.center,
                  image: AssetImage(imagePath),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                subText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Constant.locationServiceGreen,
                    fontSize: 15,
                    height: 1.3,
                    fontFamily: Constant.jostRegular),
              ),
            ],
          ),
        ),
      ),
    );
  }






}
