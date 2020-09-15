import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class SignUpLocationServices extends StatefulWidget {
  @override
  _SignUpLocationServicesState createState() => _SignUpLocationServicesState();
}

class _SignUpLocationServicesState extends State<SignUpLocationServices> {
  bool _locationServicesSwitchState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Constant.enableLocationServices,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Constant.chatBubbleGreen,
                  fontFamily: 'FuturaMaxiLight',
                ),
              ),
              Switch(
                value: _locationServicesSwitchState,
                onChanged: (bool state) {
                  setState(() {
                    _locationServicesSwitchState = state;
                    print(state);
                  });
                },
                activeColor: Constant.chatBubbleGreen,
                inactiveThumbColor: Constant.chatBubbleGreen,
                inactiveTrackColor: Constant.chatBubbleGreenBlue,
              ),
            ],
          ),
          SizedBox(height: 20,),
          Text(
            Constant.enableLocationRecommended,
            style: TextStyle(
                height: 1.5,
                fontSize: 15,
                color: Constant.locationServiceGreen,
                fontFamily: 'FuturaMaxiLight'
            ),
          ),
        ],
      ),
    );
  }
}
