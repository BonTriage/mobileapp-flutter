import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class AddHeadacheSuccessScreen extends StatefulWidget {
  @override
  _AddHeadacheSuccessScreenState createState() => _AddHeadacheSuccessScreenState();
}

class _AddHeadacheSuccessScreenState extends State<AddHeadacheSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName(Constant.homeRouter));
        return false;
      },
      child: Scaffold(
        body: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: mediaQueryData.textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
          ),
          child: Container(
            decoration: Constant.backgroundBoxDecoration,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height
                ),
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    decoration: BoxDecoration(
                      color: Constant.backgroundColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.popUntil(context, ModalRoute.withName(Constant.homeRouter));
                              },
                              child: Image(
                                image: AssetImage(Constant.closeIcon),
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ),
                        SizedBox(height: 80,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              Constant.headacheAdded,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              Constant.logYourDayToAssess,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 80,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: BouncingWidget(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, Constant.logDayScreenRouter);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Constant.chatBubbleGreen,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  Constant.logDay,
                                  style: TextStyle(
                                      color: Constant.bubbleChatTextView,
                                      fontSize: 15,
                                      fontFamily: Constant.jostMedium),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: BouncingWidget(
                            onPressed: () {
                              _popAndSaveDataInSharePreference();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.3, color: Constant.chatBubbleGreen),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  Constant.viewTrends,
                                  style: TextStyle(
                                      color: Constant.chatBubbleGreen,
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
              ),
            ),
          ),
        ),
      ),
    )
    );
  }

  void _popAndSaveDataInSharePreference() async {
    await Utils.saveDataInSharedPreference(Constant.isViewTrendsClicked, Constant.trueString);
    Navigator.popUntil(context, ModalRoute.withName(Constant.homeRouter));
  }
}
