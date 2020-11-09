import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class ApiLoaderScreen extends StatefulWidget {
  @override
  _ApiLoaderScreenState createState() => _ApiLoaderScreenState();
}

class _ApiLoaderScreenState extends State<ApiLoaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Constant.chatBubbleGreen,
          ),
          SizedBox(height: 10,),
          Text(
            Constant.loading,
            style: TextStyle(
              fontFamily: Constant.jostRegular,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Constant.chatBubbleGreen
            ),
          ),
        ],
      ),
    );
  }
}
