import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class MoreNameScreen extends StatefulWidget {
  @override
  _MoreNameScreenState createState() =>
      _MoreNameScreenState();
}

class _MoreNameScreenState
    extends State<MoreNameScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Constant.moreBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(Constant.leftArrow),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            Constant.name,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontSize: 15,
                          fontFamily: Constant.jostMedium),
                      cursorColor: Constant.locationServiceGreen,
                      decoration: InputDecoration(
                        hintText: Constant.nameHint,
                        hintStyle: TextStyle(
                            color: Constant.locationServiceGreen.withOpacity(0.5),
                            fontSize: 15,
                            fontFamily: Constant.jostMedium),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Constant.locationServiceGreen)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Constant.locationServiceGreen)),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Constant.tapToTypeYourName,
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontSize: 14,
                          fontFamily: Constant.jostMedium
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
