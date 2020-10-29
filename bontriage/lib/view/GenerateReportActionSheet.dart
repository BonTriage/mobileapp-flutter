import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class GenerateReportActionSheet extends StatefulWidget {
  @override
  _GenerateReportActionSheetState createState() => _GenerateReportActionSheetState();
}

class _GenerateReportActionSheetState extends State<GenerateReportActionSheet> {
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
                color: Constant.whiteColorAlpha85
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.lindaJonesPdf);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.lindaJonesPdf,
                        style: TextStyle(
                          color: Constant.greyColor,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Constant.actionSheetDividerColor,
                  height: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.email);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.email,
                        style: TextStyle(
                          color: Constant.cancelBlueColor,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Constant.actionSheetDividerColor,
                  height: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.text);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.text,
                        style: TextStyle(
                          color: Constant.cancelBlueColor,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Constant.actionSheetDividerColor,
                  height: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.openYourProviderApp);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.openYourProviderApp,
                        style: TextStyle(
                          color: Constant.cancelBlueColor,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Constant.actionSheetDividerColor,
                  height: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.print);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.print,
                        style: TextStyle(
                          color: Constant.cancelBlueColor,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8,),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
                    color: Constant.cancelBlueColor,
                    fontSize: 18,
                    fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
