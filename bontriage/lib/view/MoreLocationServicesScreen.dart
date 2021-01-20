import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class MoreLocationServicesScreen extends StatefulWidget {
  @override
  _MoreLocationServicesScreenState createState() =>
      _MoreLocationServicesScreenState();
}

class _MoreLocationServicesScreenState
    extends State<MoreLocationServicesScreen> {
  bool _locationServicesSwitchState;
  bool _isCheckingLocation;

  @override
  void initState() {
    super.initState();

    _locationServicesSwitchState = false;
    _isCheckingLocation = false;
  }

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
                    behavior: HitTestBehavior.translucent,
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
                          child: CupertinoSwitch(
                            value: _locationServicesSwitchState,
                            onChanged: (bool state) {
                              if(!_isCheckingLocation) {
                                if (state) {
                                  setState(() {
                                    _locationServicesSwitchState = state;
                                  });
                                  _checkLocationPermission();
                                } else {
                                  setState(() {
                                    _locationServicesSwitchState = state;
                                  });
                                }
                              }
                            },
                            activeColor: Constant.chatBubbleGreen.withOpacity(0.6),
                            trackColor: Constant.chatBubbleGreen.withOpacity(0.2),
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

  Future<void> _checkLocationPermission() async {
    _isCheckingLocation = true;
    Position position = await Utils.determinePosition();

    setState(() {
      _locationServicesSwitchState = position != null;
      _isCheckingLocation = false;
    });
  }
}
