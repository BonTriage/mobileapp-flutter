import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'dart:io' show Platform;

class SaveAndExitActionSheet extends StatefulWidget {
  @override
  _SaveAndExitActionSheetState createState() => _SaveAndExitActionSheetState();
}

class _SaveAndExitActionSheetState extends State<SaveAndExitActionSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.saveAndExit);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.saveAndExit,
                        style: TextStyle(
                          color: Constant.cancelBlueColor,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  behavior: HitTestBehavior.translucent,
                ),
              ],
            ),
          ),
          SizedBox(height: 8,),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context, Constant.cancel);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: Center(
                child: Text(
                  Constant.cancel,
                  style: TextStyle(
                    color: Constant.deleteLogRedColor,
                    fontSize: 18,
                    fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Platform.isAndroid ? 10 : 15)
        ],
      ),
    );
  }
}
