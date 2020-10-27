import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class MoreFaqScreen extends StatefulWidget {
  @override
  _MoreFaqScreenState createState() => _MoreFaqScreenState();
}

class _MoreFaqScreenState extends State<MoreFaqScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            Constant.faq,
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
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              Constant.questionOne,
                              style: TextStyle(
                                color: Constant.addCustomNotificationTextColor,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              Constant.anInsightfulAndWellWorded,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 14,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                            Divider(
                              height: 30,
                              thickness: 0.5,
                              color: Constant.locationServiceGreen,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              Constant.theSecondQuestion,
                              style: TextStyle(
                                  color: Constant.addCustomNotificationTextColor,
                                  fontSize: 16,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              Constant.hereIsASimple,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 14,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                            Divider(
                              height: 30,
                              thickness: 0.5,
                              color: Constant.locationServiceGreen,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              Constant.whatIfMyQuestion,
                              style: TextStyle(
                                  color: Constant.addCustomNotificationTextColor,
                                  fontSize: 16,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              Constant.aMoreComplicated,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 14,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
