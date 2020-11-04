import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class MoreLocationServicesScreen extends StatefulWidget {
  @override
  _MoreLocationServicesScreenState createState() =>
      _MoreLocationServicesScreenState();
}

class _MoreLocationServicesScreenState
    extends State<MoreLocationServicesScreen> {
  bool _locationServicesSwitchState = false;

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
                            Constant.locationServices,
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                          child: Text(
                            Constant.locationServices,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostMedium
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Switch(
                            value: _locationServicesSwitchState,
                            onChanged: (bool state) {
                              setState(() {
                                _locationServicesSwitchState = state;
                              });
                            },
                            activeColor: Constant.chatBubbleGreen,
                            inactiveThumbColor: Constant.chatBubbleGreen,
                            inactiveTrackColor: Constant.chatBubbleGreenBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Constant.enablingLocationServices,
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
