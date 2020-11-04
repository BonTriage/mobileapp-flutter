import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class MedicalHelpActionSheet extends StatefulWidget {
  @override
  _MedicalHelpActionSheetState createState() => _MedicalHelpActionSheetState();
}

class _MedicalHelpActionSheetState extends State<MedicalHelpActionSheet> {
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
                    Navigator.pop(context, Constant.medicalHelp);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.medicalHelp,
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
                    Navigator.pop(context, Constant.call911);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.call911,
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
                Divider(
                  thickness: 0.5,
                  color: Constant.actionSheetDividerColor,
                  height: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.callADoctor);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.callADoctor,
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
                    Navigator.pop(context, Constant.findALocalDoctor);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.findALocalDoctor,
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
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
